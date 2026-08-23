import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/breeds_provider.dart';
import '../providers/rabbits_provider.dart';
import '../widgets/rabbit_picker.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../utils/rabbit_labels.dart';

class RabbitFormScreen extends ConsumerStatefulWidget {
  final int? rabbitId;
  final RabbitModel? rabbit;

  const RabbitFormScreen({
    super.key,
    this.rabbitId,
    this.rabbit,
  });

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
  int? _selectedFatherId;
  int? _selectedMotherId;
  RabbitModel? _father;
  RabbitModel? _mother;
  String? _fatherLabel;
  String? _motherLabel;
  String _selectedSex = 'male';
  String _selectedStatus = 'healthy';
  String _selectedPurpose = 'breeding';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 60));
  bool _isLoading = false;
  XFile? _selectedImage;
  String? _currentPhotoUrl;
  Uint8List? _webImageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.rabbit != null) {
      _loadRabbitDataFromModel(widget.rabbit!);
    } else if (widget.rabbitId != null) {
      Future.microtask(() => _loadRabbitFromProvider());
    } else {
      _tagIdController.text = _suggestedTag();
    }
  }

  /// Номер бирки человек пишет на ушной бирке от руки, поэтому он должен быть
  /// коротким. Раньше подставлялась метка времени вида «R-1787510574403»:
  /// переписать её на бирку невозможно, и её оставляли как есть.
  String _suggestedTag() {
    final next = ref.read(rabbitsListProvider).total + 1;
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
                '${context.l10n.rabbitFormLoadFailed}: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _loadRabbitDataFromModel(RabbitModel rabbit) {
    _nameController.text = rabbit.name;
    _tagIdController.text = rabbit.tagId;
    _colorController.text = rabbit.color ?? '';
    _weightController.text = rabbit.currentWeight?.toString() ?? '';
    _notesController.text = rabbit.notes ?? '';
    _selectedBreedId = rabbit.breedId;
    _selectedFatherId = rabbit.fatherId;
    _selectedMotherId = rabbit.motherId;
    _fatherLabel = rabbit.father?.name;
    _motherLabel = rabbit.mother?.name;
    _selectedSex = rabbit.sex;
    _selectedStatus = rabbit.status;
    _selectedPurpose = rabbit.purpose;
    _birthDate = rabbit.birthDate;
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
                  title: Text(context.l10n.rabbitFormPhotoRemove,
                      style: TextStyle(color: AppColors.error)),
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
        'sex': _selectedSex,
        'birth_date': _birthDate.toIso8601String(),
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

      if (isEditMode && widget.rabbitId != null) {
        ref.invalidate(rabbitDetailProvider(widget.rabbitId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode ? context.l10n.rabbitFormUpdated : context.l10n.rabbitFormCreated),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode
            ? context.l10n.rabbitFormEditTitle
            : context.l10n.rabbitFormNewTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Photo section
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
                                      ? Image.memory(_webImageBytes!,
                                          fit: BoxFit.cover)
                                      : Icon(Icons.image,
                                          size: 60,
                                          color: cs.onSurfaceVariant))
                                  : Image.file(File(_selectedImage!.path),
                                      fit: BoxFit.cover),
                            )
                          : displayPhotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    displayPhotoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.pets,
                                          size: 60,
                                          color: cs.onSurfaceVariant);
                                    },
                                  ),
                                )
                              : Icon(Icons.add_a_photo,
                                  size: 60, color: cs.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 8),
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
            const SizedBox(height: 8),

            AppFormSection(
              title: context.l10n.commonSectionMain,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.rabbitFormName,
                    hintText: context.l10n.rabbitFormNameHint,
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.rabbitFormNameEmpty;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tagIdController,
                  decoration: InputDecoration(
                    labelText: context.l10n.rabbitFormTag,
                    hintText: 'R-XXX',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.rabbitFormTagEmpty;
                    }
                    return null;
                  },
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
                else
                  DropdownButtonFormField<int>(
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
                    validator: (value) =>
                        value == null ? context.l10n.rabbitFormBreedRequired : null,
                  ),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSex,
                  decoration: InputDecoration(
                    labelText: context.l10n.rabbitSex,
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'male', child: Text(context.l10n.sexMale)),
                    DropdownMenuItem(
                        value: 'female', child: Text(context.l10n.sexFemale)),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedSex = value!),
                ),
                AppDateField(
                  label: context.l10n.rabbitBirthDate,
                  value: _birthDate,
                  onChanged: (date) => setState(() => _birthDate = date),
                  prefixIcon: Icons.cake,
                  lastDate: DateTime.now(),
                ),
              ],
            ),

            AppFormSection(
              title: context.l10n.rabbitPedigree,
              children: [
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
              ],
            ),

            AppFormSection(
              title: context.l10n.commonSectionDetails,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: context.l10n.rabbitStatus,
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  items: [
                    for (final status in rabbitStatuses)
                      DropdownMenuItem(
                        value: status,
                        child: Text(rabbitStatusLabel(context, status)),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedStatus = value!),
                ),
                DropdownButtonFormField<String>(
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
                    suffixText: 'кг',
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
              ],
            ),

            AppFormSection(
              title: context.l10n.rabbitFormNotes,
              children: [
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: context.l10n.rabbitFormNotes,
                    hintText: context.l10n.rabbitFormNotesHint,
                    prefixIcon: Icon(Icons.notes),
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
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditMode ? context.l10n.commonSave : context.l10n.commonAdd),
            ),
          ),
        ),
      ),
    );
  }
}
