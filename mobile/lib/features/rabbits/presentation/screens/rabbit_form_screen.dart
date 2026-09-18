import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/breeds_provider.dart';
import '../providers/rabbits_provider.dart';
import '../widgets/rabbit_picker.dart';
import '../../../../core/access/farm_access.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../utils/rabbit_labels.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/widgets/app_form_disclosure.dart';
import '../../../../core/widgets/app_form_scaffold.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/voice/voice_input.dart';
import '../../../cages/data/models/cage_model.dart';
import '../../../cages/presentation/providers/cages_provider.dart';
import '../../../../core/widgets/plan_limit_dialog.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/cache/cache_scope.dart';
import '../../../../core/forms/form_draft.dart';
import '../../../../core/providers/after_write.dart';

class RabbitFormScreen extends ConsumerStatefulWidget {
  final int? rabbitId;
  final RabbitModel? rabbit;

  /// Клетка, из которой открыли форму. Кролика заводят, стоя у клетки, —
  /// и если пришли с её экрана, спрашивать «в какой клетке» незачем.
  final int? cageId;

  const RabbitFormScreen({super.key, this.rabbitId, this.rabbit, this.cageId});

  @override
  ConsumerState<RabbitFormScreen> createState() => _RabbitFormScreenState();
}

class _RabbitFormScreenState extends ConsumerState<RabbitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tagIdController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  final _imagePicker = ImagePicker();

  int? _selectedBreedId;
  int? _selectedCageId;
  int? _selectedFatherId;
  int? _selectedMotherId;
  RabbitModel? _father;
  RabbitModel? _mother;
  String? _fatherLabel;
  String? _motherLabel;

  /// Пола по умолчанию нет намеренно: «самец» стоял здесь заранее, и
  /// половина ферм заводила самок самцами, просто не тронув поле.
  String? _selectedSex;
  String _selectedStatus = 'healthy';

  /// Статус, с которым кролика открыли. Нужен списку статусов: выбывшего
  /// кролика он должен показать самим собой, даже когда «продан» и «пал»
  /// больше не предлагаются.
  String? _loadedStatus;
  String _selectedPurpose = 'breeding';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 60));

  /// Когда кролика купили. У покупного кролика дата рождения — со слов
  /// продавца, а день, когда он появился на ферме, хозяин знает точно; по
  /// нему и считают, сколько он здесь живёт и когда окупился. Поле было в
  /// модели и на сервере, а заполнить его было негде.
  DateTime? _acquiredDate;
  bool _isLoading = false;
  bool _touched = false;
  XFile? _selectedImage;
  String? _currentPhotoUrl;
  Uint8List? _webImageBytes;

  /// Недописанное переживает смерть приложения — как и в остальных формах
  /// (`core/forms/form_draft.dart`). Эта форма собирает экран сама, поэтому
  /// черновик здесь тоже ведётся вручную.
  late final FormDraft _draft = FormDraft(
    key: 'rabbit-${widget.rabbit?.id ?? widget.rabbitId ?? 'new'}',
    fields: {
      'name': _nameController,
      'tag': _tagIdController,
      'color': _colorController,
      'weight': _weightController,
      'notes': _notesController,
    },
  );

  FormDraftStore get _drafts => FormDraftStore(ref.read(cacheScopeProvider));

  Future<void> _restoreDraft() async {
    final saved = await _drafts.read(_draft.key);
    if (saved == null || saved.isEmpty || !mounted) return;

    setState(() => _draft.apply(saved));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.formDraftRestored),
        action: SnackBarAction(
          label: context.l10n.formDraftDiscard,
          onPressed: () {
            for (final field in _draft.fields.values) {
              field.clear();
            }
            _drafts.forget(_draft.key);
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreDraft());
    if (widget.rabbit != null) {
      _loadRabbitDataFromModel(widget.rabbit!);
    } else if (widget.rabbitId != null) {
      Future.microtask(() => _loadRabbitFromProvider());
    } else {
      _tagIdController.text = _suggestedTag();
      _selectedCageId = widget.cageId;
      // Назначение хозяйства: ферма обычно держит кроликов для чего-то
      // одного, и спрашивать об этом на каждой карточке незачем. Хозяйство
      // ещё не сказало — остаётся «племя», как и на сервере.
      _selectedPurpose =
          ref.read(farmDefaultPurposeProvider) ?? _selectedPurpose;
      Future.microtask(_restoreLastBreed);
    }
  }

  /// На ферме держат одну-две породы, и вторую сотню кроликов выбирают ту же
  /// самую. Подставленная порода убирает одно из трёх решений на записи.
  static const _lastBreedKey = 'rabbit_form_last_breed_id';

  Future<void> _restoreLastBreed() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_lastBreedKey);
    if (id == null || !mounted || _selectedBreedId != null) return;
    setState(() => _selectedBreedId = id);
  }

  Future<void> _rememberBreed() async {
    final id = _selectedBreedId;
    if (id == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastBreedKey, id);
  }

  /// Номер бирки человек пишет на ушной бирке от руки, поэтому он должен быть
  /// коротким. Раньше подставлялась метка времени вида «R-1787510574403»:
  /// переписать её на бирку невозможно, и её оставляли как есть.
  ///
  /// Счёт берётся только из нефильтрованного списка. При включённом отборе
  /// `total` — это число найденных, а не всё поголовье: с фильтром «самки»
  /// на сотне кроликов форма предлагала номер из третьего десятка, который
  /// давно занят, и сохранение упиралось в отказ про дубликат клейма.
  String _suggestedTag() {
    final state = ref.read(rabbitsListProvider);
    if (!state.filter.isEmpty) return '';

    final next = state.total + 1;
    return 'R-${next.toString().padLeft(3, '0')}';
  }

  Future<void> _loadRabbitFromProvider() async {
    try {
      final rabbit = await ref
          .read(rabbitsRepositoryProvider)
          .getRabbitById(widget.rabbitId!);
      if (mounted) {
        _loadRabbitDataFromModel(rabbit);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.l10n.rabbitFormLoadFailed}: ${errorText(context.l10n, e)}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _loadRabbitDataFromModel(RabbitModel rabbit) {
    _nameController.text = rabbit.name ?? '';
    _tagIdController.text = rabbit.tagId ?? '';
    _colorController.text = rabbit.color ?? '';
    _weightController.text = rabbit.currentWeight?.toString() ?? '';
    _notesController.text = rabbit.notes ?? '';
    _selectedBreedId = rabbit.breedId;
    _selectedCageId = rabbit.cageId;
    _selectedFatherId = rabbit.fatherId;
    _selectedMotherId = rabbit.motherId;
    _fatherLabel = rabbit.father?.name;
    _motherLabel = rabbit.mother?.name;
    _selectedSex = rabbit.sex;
    _selectedStatus = rabbit.status;
    _loadedStatus = rabbit.status;
    _selectedPurpose = rabbit.purpose;
    _birthDate = rabbit.birthDate;
    _acquiredDate = rabbit.acquiredDate;
    _currentPhotoUrl = rabbit.photoUrl;
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagIdController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image != null) {
        Uint8List? bytes;
        if (kIsWeb) bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = image;
          _webImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.rabbitFormPhotoFailed),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image != null) {
        Uint8List? bytes;
        if (kIsWeb) bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = image;
          _webImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.rabbitFormPhotoFailed),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
      _currentPhotoUrl = null;
      _webImageBytes = null;
    });
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(context.l10n.rabbitFormPhotoGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(context.l10n.rabbitFormPhotoCamera),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              if (_selectedImage != null || _currentPhotoUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: AppColors.error),
                  title: Text(
                    context.l10n.rabbitFormPhotoRemove,
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeSelectedImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text.trim(),
        'tag_id': _tagIdController.text.trim(),
        'breed_id': _selectedBreedId,
        // Клетка отправляется всегда, включая null: кролика переселяют и
        // высаживают, и «поле не пришло» сервер трактует как «оставить как
        // было» — освободить клетку стало бы невозможно.
        'cage_id': _selectedCageId,
        'sex': _selectedSex,
        'birth_date': _birthDate.toIso8601String(),
        // Отправляется всегда, включая null: дату покупки убирают, если
        // кролик оказался своим, а «поле не пришло» сервер читает как
        // «оставить как было».
        'acquired_date': _acquiredDate?.toIso8601String().split('T').first,
        'status': _selectedStatus,
        'purpose': _selectedPurpose,
        // Ключи отправляются всегда, включая null: раньше убранный родитель
        // просто не попадал в запрос, и сервер оставлял прежнего.
        'father_id': _selectedFatherId,
        'mother_id': _selectedMotherId,
        if (_colorController.text.isNotEmpty)
          'color': _colorController.text.trim(),
        if (_weightController.text.isNotEmpty)
          'current_weight': double.parse(_weightController.text),
        if (_notesController.text.isNotEmpty)
          'notes': _notesController.text.trim(),
      };

      final isEditMode = widget.rabbitId != null || widget.rabbit != null;
      int rabbitId;

      if (isEditMode) {
        rabbitId = widget.rabbitId ?? widget.rabbit!.id;
        await ref.read(rabbitsRepositoryProvider).updateRabbit(rabbitId, data);
      } else {
        final createdRabbit =
            await ref.read(rabbitsRepositoryProvider).createRabbit(data);
        rabbitId = createdRabbit.id;
        Analytics.rabbitAdded();
        await _rememberBreed();
      }

      if (_selectedImage != null) {
        try {
          await ref.read(rabbitsRepositoryProvider).uploadPhoto(
                rabbitId,
                _selectedImage!.path,
                bytes: _webImageBytes,
              );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.rabbitFormPhotoFailed),
                backgroundColor: AppColors.warning,
              ),
            );
          }
        }
      } else if (_currentPhotoUrl == null && isEditMode) {
        try {
          await ref.read(rabbitsRepositoryProvider).deletePhoto(rabbitId);
        } catch (e) {
          // Ignore errors when deleting photo
        }
      }

      ref.read(rabbitsListProvider.notifier).refresh();
      ref.refreshAfter(FarmRecord.rabbit);
      if (_selectedCageId != null) {
        ref.invalidate(cageDetailProvider(_selectedCageId!));
      }

      if (isEditMode && widget.rabbitId != null) {
        ref.invalidate(rabbitDetailProvider(widget.rabbitId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? context.l10n.rabbitFormUpdated
                  : context.l10n.rabbitFormCreated,
            ),
          ),
        );
        // Запись сохранена — черновику больше нечего переживать.
        _drafts.forget(_draft.key);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        // Лимит тарифа не лечится повтором — фермеру нужно объяснение и
        // понятный следующий шаг, а не текст ошибки в снекбаре.
        if (e is ApiFailure && e.code == 'RABBIT_LIMIT_REACHED') {
          showPlanLimitReachedDialog(
            context,
            title: context.l10n.planLimitRabbitsTitle,
            body: context.l10n.planLimitRabbitsBody,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorText(context.l10n, e)),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final breedsState = ref.watch(breedsProvider);
    final isEditMode = widget.rabbitId != null || widget.rabbit != null;
    final displayPhotoUrl = ImageUrlHelper.getFullImageUrl(_currentPhotoUrl);

    // Единственная форма, которая собирает экран сама, а не через
    // AppFormScaffold: заполненные поля пропадали по кнопке «назад» без
    // единого вопроса.
    return PopScope(
      canPop: !_touched && !_isLoading,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || _isLoading) return;
        if (await confirmDiscardChanges(context) && context.mounted) {
          // Сказал «выйти без сохранения» — значит написанное ему не нужно.
          _drafts.forget(_draft.key);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode
                ? context.l10n.rabbitFormEditTitle
                : context.l10n.rabbitFormNewTitle,
          ),
        ),
        body: Form(
          key: _formKey,
          onChanged: () {
            setState(() => _touched = true);
            _drafts.write(_draft.key, _draft.snapshot());
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.lg,
              AppSpacing.screenH,
              AppSpacing.fabSafeBottom,
            ),
            children: [
              // Главное — ровно три решения, без которых записи не будет:
              // кто это, когда родился и какой породы. Остальное либо
              // подставляется, либо не нужно в момент записи. Прежняя форма
              // спрашивала одиннадцать полей подряд, и на словах фермера это
              // звучало так: «всех своих кроликов по одному вбивать не буду».
              AppFormSection(
                title: context.l10n.commonSectionMain,
                children: [
                  _SexField(
                    value: _selectedSex,
                    onChanged: (value) => setState(() {
                      _selectedSex = value;
                      _touched = true;
                    }),
                  ),
                  AppDateField(
                    label: context.l10n.rabbitBirthDate,
                    value: _birthDate,
                    onChanged: (date) => setState(() => _birthDate = date),
                    prefixIcon: Icons.cake,
                    lastDate: DateTime.now(),
                  ),
                  if (breedsState.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (breedsState.error != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        context.l10n.rabbitFormBreedsFailed,
                        style: TextStyle(color: cs.error),
                      ),
                    )
                  else if (breedsState.breeds.isEmpty)
                    // Пустой справочник раньше рисовался обычным выпадающим
                    // полем: человек жал на него, список не открывался, а
                    // сохранение отвечало «выберите породу». Выбрать было не
                    // из чего, и карточка первого кролика становилась тупиком.
                    AppEmptyState(
                      icon: Icons.category_outlined,
                      title: context.l10n.rabbitFormBreedsEmpty,
                      subtitle: context.l10n.rabbitFormBreedsEmptyHint,
                      actionLabel: context.l10n.rabbitFormBreedsEmptyAction,
                      onAction: () async {
                        await context.push('/breeds/form');
                        if (!context.mounted) return;
                        ref.invalidate(breedsProvider);
                      },
                    )
                  else
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      initialValue: _selectedBreedId,
                      decoration: InputDecoration(
                        labelText: context.l10n.rabbitBreed,
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: breedsState.breeds.map((breed) {
                        return DropdownMenuItem(
                          value: breed.id,
                          child: Text(breed.name),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedBreedId = value),
                      validator: (value) => value == null
                          ? context.l10n.rabbitFormBreedRequired
                          : null,
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              AppFormDisclosure(
                title: context.l10n.rabbitFormMore,
                // При правке всё раскрыто сразу: свёрнутый блок поверх
                // заполненных полей читается как «данные потерялись».
                initiallyExpanded: isEditMode,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _showImageSourceDialog,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cs.outline, width: 2),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: kIsWeb
                                        ? (_webImageBytes != null
                                            ? Image.memory(
                                                _webImageBytes!,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Icons.image,
                                                size: 60,
                                                color: cs.onSurfaceVariant,
                                              ))
                                        : Image.file(
                                            File(_selectedImage!.path),
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : displayPhotoUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          displayPhotoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.pets,
                                              size: 60,
                                              color: cs.onSurfaceVariant,
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
                                        Icons.add_a_photo,
                                        size: 60,
                                        color: cs.onSurfaceVariant,
                                      ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: _showImageSourceDialog,
                          icon: const Icon(Icons.camera_alt),
                          label: Text(
                            _selectedImage != null || displayPhotoUrl != null
                                ? context.l10n.rabbitFormPhotoChange
                                : context.l10n.rabbitFormPhotoAdd,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _tagIdController,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitFormTag,
                      hintText: 'R-XXX',
                      prefixIcon: Icon(Icons.tag),
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitFormName,
                      hintText: context.l10n.rabbitFormNameHint,
                      prefixIcon: Icon(Icons.pets),
                    ),
                  ),
                  // Пусто — значит родился здесь. Дату рождения покупного
                  // кролика называет продавец, а день покупки хозяин знает
                  // точно: по нему считают, сколько кролик живёт на ферме и
                  // когда окупился.
                  AppDateField(
                    label: context.l10n.rabbitAcquiredDate,
                    value: _acquiredDate,
                    placeholder: context.l10n.rabbitAcquiredDateEmpty,
                    prefixIcon: Icons.shopping_bag_outlined,
                    lastDate: DateTime.now(),
                    onChanged: (date) => setState(() {
                      _acquiredDate = date;
                      _touched = true;
                    }),
                    onCleared: () => setState(() {
                      _acquiredDate = null;
                      _touched = true;
                    }),
                  ),
                  _CageField(
                    value: _selectedCageId,
                    onChanged: (value) => setState(() {
                      _selectedCageId = value;
                      _touched = true;
                    }),
                  ),
                  // Родитель выбирается поиском по серверу: прежний виджет
                  // предлагал только тех кроликов, что успели подгрузиться в
                  // постраничный список.
                  RabbitPickerField(
                    label: context.l10n.rabbitFather,
                    icon: Icons.male,
                    sex: 'male',
                    selected: _father,
                    selectedLabel: _fatherLabel,
                    excludeId: widget.rabbitId ?? widget.rabbit?.id,
                    onChanged: (rabbit) => setState(() {
                      _father = rabbit;
                      _fatherLabel = null;
                      _selectedFatherId = rabbit?.id;
                    }),
                  ),
                  RabbitPickerField(
                    label: context.l10n.rabbitMother,
                    icon: Icons.female,
                    sex: 'female',
                    selected: _mother,
                    selectedLabel: _motherLabel,
                    excludeId: widget.rabbitId ?? widget.rabbit?.id,
                    onChanged: (rabbit) => setState(() {
                      _mother = rabbit;
                      _motherLabel = null;
                      _selectedMotherId = rabbit?.id;
                    }),
                  ),
                  // Выбытие отсюда не отмечают. «Продан» и «Пал» здесь
                  // ставились без цены, без покупателя, без дня и без причины
                  // — и именно так продажа теряла приход в книге, а падёж
                  // оставался статусом без объяснения. У каждого из двух
                  // теперь свой экран с карточки кролика.
                  //
                  // Уже выбывший кролик свой статус в списке видит: иначе
                  // список не нашёл бы своего значения, а ошибочную продажу
                  // нельзя было бы отменить, вернув кролика в живые.
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitStatus,
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                    items: [
                      for (final status in rabbitStatuses)
                        if (!rabbitStatusesTerminal.contains(status) ||
                            status == _loadedStatus)
                          DropdownMenuItem(
                            value: status,
                            child: Text(rabbitStatusLabel(context, status)),
                          ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedStatus = value!),
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedPurpose,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitPurpose,
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    items: [
                      for (final purpose in rabbitPurposes)
                        DropdownMenuItem(
                          value: purpose,
                          child: Text(rabbitPurposeLabel(context, purpose)),
                        ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedPurpose = value!),
                  ),
                  TextFormField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitFormColor,
                      hintText: context.l10n.rabbitFormColorHint,
                      prefixIcon: Icon(Icons.palette_outlined),
                    ),
                  ),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitFormWeight,
                      hintText: '0.0',
                      prefixIcon: Icon(Icons.monitor_weight_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (double.tryParse(value) == null) {
                          return context.l10n.commonNumberInvalid;
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: context.l10n.rabbitFormNotes,
                      hintText: context.l10n.rabbitFormNotesHint,
                      prefixIcon: Icon(Icons.notes),
                      suffixIcon:
                          VoiceInputButton(controller: _notesController),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: AppSizes.touchTargetLarge,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isEditMode
                            ? context.l10n.commonSave
                            : context.l10n.commonAdd,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Самец или самка — выбор из двух, а не список.
///
/// Раньше это был выпадающий список с заранее выбранным «самцом»: два
/// нажатия там, где хватает одного, и тихая ошибка у всех, кто поле не
/// тронул. Здесь оба варианта видны сразу, и ни один не выбран заранее —
/// пол кролика приложение угадать не может.
class _SexField extends StatelessWidget {
  const _SexField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FormField<String>(
      initialValue: value,
      validator: (_) => value == null ? l10n.rabbitFormSexRequired : null,
      builder: (field) {
        final error = field.errorText;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rabbitSex,
              style: context.text.labelLarge?.copyWith(
                color: error == null
                    ? context.colors.onSurfaceVariant
                    : context.colors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: AppSizes.touchTargetLarge,
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'female',
                    icon: const Icon(Icons.female),
                    label: Text(l10n.sexFemale),
                  ),
                  ButtonSegment(
                    value: 'male',
                    icon: const Icon(Icons.male),
                    label: Text(l10n.sexMale),
                  ),
                ],
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                selected: value == null ? const <String>{} : {value!},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) return;
                  onChanged(selection.first);
                  field.didChange(selection.first);
                },
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                error,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// В какой клетке живёт кролик.
///
/// Поле новое: `cage_id` у кролика был с самого начала и заполнялся только
/// с экрана клетки, а в форме кролика клетки не было вовсе — карточка
/// показывала «клетка не указана» и изменить это из неё было нельзя.
///
/// Полные клетки из списка не убираются, а помечаются: человек лучше знает,
/// сколько кроликов влезет в его клетку, чем поле «вместимость».
class _CageField extends ConsumerWidget {
  const _CageField({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cages = ref.watch(cageOptionsProvider);

    return DropdownButtonFormField<int?>(
      isExpanded: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: l10n.rabbitCage,
        prefixIcon: const Icon(Icons.grid_view_outlined),
      ),
      items: [
        DropdownMenuItem<int?>(
          value: null,
          child: Text(l10n.rabbitFormCageNone),
        ),
        for (final cage in cages.value ?? const <CageModel>[])
          DropdownMenuItem<int?>(
            value: cage.id,
            child: Text(
              cage.isFull == true
                  ? l10n.rabbitFormCageFull(cage.number)
                  : cage.number,
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
