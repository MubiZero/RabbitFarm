import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/breeds_provider.dart';
import '../providers/rabbits_provider.dart';
import '../widgets/parent_selector.dart';
import '../../../../core/utils/image_url_helper.dart';

class RabbitFormScreen extends ConsumerStatefulWidget {
  final int? rabbitId; // ID for edit mode
  final RabbitModel? rabbit; // Pre-loaded rabbit data (optional)

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
      // Load rabbit data from provider
      Future.microtask(() => _loadRabbitFromProvider());
    } else {
      // Generate tag ID for new rabbit
      _tagIdController.text = 'R-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _loadRabbitFromProvider() async {
    try {
      final rabbit = await ref.read(rabbitsRepositoryProvider).getRabbitById(widget.rabbitId!);
      if (mounted) {
        _loadRabbitDataFromModel(rabbit);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
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
    _selectedSex = rabbit.sex;
    _selectedStatus = rabbit.status;
    _selectedPurpose = rabbit.purpose;
    _birthDate = rabbit.birthDate;
    _currentPhotoUrl = rabbit.photoUrl;
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

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('ru'),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
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
        if (kIsWeb) {
          bytes = await image.readAsBytes();
        }
        setState(() {
          _selectedImage = image;
          _webImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выбора фото: ${e.toString()}'),
            backgroundColor: Colors.red,
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
        if (kIsWeb) {
          bytes = await image.readAsBytes();
        }
        setState(() {
          _selectedImage = image;
          _webImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка фото с камеры: ${e.toString()}'),
            backgroundColor: Colors.red,
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
                title: const Text('Выбрать из галереи'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Сделать фото'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              if (_selectedImage != null || _currentPhotoUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Удалить фото', style: TextStyle(color: Colors.red)),
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
    if (_selectedBreedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите породу'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'name': _nameController.text.trim(),
        'tag_id': _tagIdController.text.trim(),
        'breed_id': _selectedBreedId,
        'sex': _selectedSex,
        'birth_date': _birthDate.toIso8601String(),
        'status': _selectedStatus,
        'purpose': _selectedPurpose,
        if (_selectedFatherId != null) 'father_id': _selectedFatherId,
        if (_selectedMotherId != null) 'mother_id': _selectedMotherId,
        if (_colorController.text.isNotEmpty) 'color': _colorController.text.trim(),
        if (_weightController.text.isNotEmpty)
          'current_weight': double.parse(_weightController.text),
        if (_notesController.text.isNotEmpty) 'notes': _notesController.text.trim(),
      };

      final isEditMode = widget.rabbitId != null || widget.rabbit != null;
      int rabbitId;

      if (isEditMode) {
        // Update
        rabbitId = widget.rabbitId ?? widget.rabbit!.id;
        await ref.read(rabbitsRepositoryProvider).updateRabbit(rabbitId, data);
      } else {
        // Create
        final createdRabbit = await ref.read(rabbitsRepositoryProvider).createRabbit(data);
        rabbitId = createdRabbit.id;
      }

      // Upload or delete photo
      if (_selectedImage != null) {
        // Upload new photo
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
                content: Text('Предупреждение: ${e.toString().replaceAll('Exception: ', '')}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else if (_currentPhotoUrl == null && isEditMode) {
        // Delete photo if it was removed in edit mode
        try {
          await ref.read(rabbitsRepositoryProvider).deletePhoto(rabbitId);
        } catch (e) {
          // Ignore errors when deleting photo
        }
      }

      // Refresh list
      ref.read(rabbitsListProvider.notifier).refresh();

      // Invalidate detail cache if editing
      if (isEditMode && widget.rabbitId != null) {
        ref.invalidate(rabbitDetailProvider(widget.rabbitId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Данные обновлены'
                  : 'Кролик добавлен',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final breedsState = ref.watch(breedsProvider);
    final isEditMode = widget.rabbitId != null || widget.rabbit != null;
    final displayPhotoUrl = ImageUrlHelper.getFullImageUrl(_currentPhotoUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Редактировать' : 'Добавить кролика'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _handleSubmit,
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Photo Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[400]!, width: 2),
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
                                      : const Icon(
                                          Icons.image,
                                          size: 60,
                                          color: Colors.grey,
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
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.pets,
                                        size: 60,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.add_a_photo,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(
                      _selectedImage != null || displayPhotoUrl != null
                          ? 'Изменить фото'
                          : 'Добавить фото',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Кличка',
                hintText: 'Введите кличку',
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите кличку';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tag ID
            TextFormField(
              controller: _tagIdController,
              decoration: const InputDecoration(
                labelText: 'Номер бирки',
                hintText: 'R-XXX',
                prefixIcon: Icon(Icons.tag),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите номер бирки';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Breed
            breedsState.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : breedsState.error != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Ошибка загрузки пород: ${breedsState.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : DropdownButtonFormField<int>(
                        value: _selectedBreedId,
                        decoration: const InputDecoration(
                          labelText: 'Порода',
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: breedsState.breeds.map((breed) {
                          return DropdownMenuItem(
                            value: breed.id,
                            child: Text(breed.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBreedId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Выберите породу';
                          }
                          return null;
                        },
                      ),
            const SizedBox(height: 16),

            // Sex
            DropdownButtonFormField<String>(
              value: _selectedSex,
              decoration: const InputDecoration(
                labelText: 'Пол',
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Самец')),
                DropdownMenuItem(value: 'female', child: Text('Самка')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSex = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Birth Date
            InkWell(
              onTap: _selectBirthDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Дата рождения',
                  prefixIcon: Icon(Icons.cake),
                ),
                child: Text(
                  DateFormat('dd.MM.yyyy').format(_birthDate),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // === РОДОСЛОВНАЯ ===
            Text(
              'Родословная',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Father Selector
            ParentSelector(
              label: 'Отец',
              sex: 'male',
              selectedParentId: _selectedFatherId,
              excludeRabbitId: widget.rabbitId ?? widget.rabbit?.id,
              onChanged: (value) {
                setState(() {
                  _selectedFatherId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Mother Selector
            ParentSelector(
              label: 'Мать',
              sex: 'female',
              selectedParentId: _selectedMotherId,
              excludeRabbitId: widget.rabbitId ?? widget.rabbit?.id,
              onChanged: (value) {
                setState(() {
                  _selectedMotherId = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // === ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ ===
            Text(
              'Дополнительные данные',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Status
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Статус',
                prefixIcon: Icon(Icons.info),
              ),
              items: const [
                DropdownMenuItem(value: 'healthy', child: Text('Здоров')),
                DropdownMenuItem(value: 'sick', child: Text('Болен')),
                DropdownMenuItem(value: 'quarantine', child: Text('Карантин')),
                DropdownMenuItem(value: 'pregnant', child: Text('Беременна')),
                DropdownMenuItem(value: 'sold', child: Text('Продан')),
                DropdownMenuItem(value: 'dead', child: Text('Умер')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Purpose
            DropdownButtonFormField<String>(
              value: _selectedPurpose,
              decoration: const InputDecoration(
                labelText: 'Назначение',
                prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(value: 'breeding', child: Text('Разведение')),
                DropdownMenuItem(value: 'meat', child: Text('Мясо')),
                DropdownMenuItem(value: 'sale', child: Text('Продажа')),
                DropdownMenuItem(value: 'show', child: Text('Выставка')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPurpose = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Color
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Окрас (опционально)',
                hintText: 'Серый, белый, черный...',
                prefixIcon: Icon(Icons.palette),
              ),
            ),
            const SizedBox(height: 16),

            // Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Вес (кг, опционально)',
                hintText: '0.0',
                prefixIcon: Icon(Icons.monitor_weight),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Заметки (опционально)',
                hintText: 'Дополнительная информация',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit button
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(
                  isEditMode ? 'Сохранить изменения' : 'Добавить кролика',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
