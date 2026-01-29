import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../constants/colors.dart';
import '../../models/donghua.dart';
import '../../providers/content_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/gradient_button.dart';

class AdminFormScreen extends StatefulWidget {
  final Donghua? donghua; // If null, we are adding. If set, we are editing.

  const AdminFormScreen({super.key, this.donghua});

  @override
  State<AdminFormScreen> createState() => _AdminFormScreenState();
}

class _AdminFormScreenState extends State<AdminFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _coverController;
  late TextEditingController _videoUrlController;
  late TextEditingController _episodesController;
  late TextEditingController _ratingController;

  String _status = 'Ongoing';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.donghua?.title ?? '');
    _descController = TextEditingController(text: widget.donghua?.description ?? '');
    _coverController = TextEditingController(text: widget.donghua?.coverUrl ?? '');
    _videoUrlController = TextEditingController(text: widget.donghua?.videoUrl ?? '');
    _episodesController = TextEditingController(text: widget.donghua?.episodes.toString() ?? '');
    _ratingController = TextEditingController(text: widget.donghua?.rating.toString() ?? '');
    if (widget.donghua != null) {
      _status = widget.donghua!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _coverController.dispose();
    _videoUrlController.dispose();
    _episodesController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final provider = Provider.of<ContentProvider>(context, listen: false);

    final donghua = Donghua(
      id: widget.donghua?.id ?? const Uuid().v4(),
      title: _titleController.text,
      description: _descController.text,
      coverUrl: _coverController.text,
      videoUrl: _videoUrlController.text,
      status: _status,
      genres: ['Action', 'Fantasy'], // Hardcoded for prototype simplicity
      rating: double.tryParse(_ratingController.text) ?? 0.0,
      episodes: int.tryParse(_episodesController.text) ?? 0,
      releaseTime: 'Just now',
    );

    if (widget.donghua == null) {
      await provider.addDonghua(donghua);
    } else {
      await provider.updateDonghua(donghua);
    }

    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.donghua == null ? 'Add Donghua' : 'Edit Donghua', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _descController.clear();
              _coverController.clear();
              _videoUrlController.clear();
            },
            child: const Text('Reset', style: TextStyle(color: AppColors.primary)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Preview (Simplified)
              const Row(children: [Icon(Icons.image, color: AppColors.primary), SizedBox(width: 8), Text('Cover Poster URL', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
              const SizedBox(height: 8),
              GlassContainer(
                color: AppColors.cardDark,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _coverController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'https://...', hintStyle: TextStyle(color: Colors.white30)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Row(children: [Icon(Icons.video_library, color: AppColors.primary), SizedBox(width: 8), Text('Video URL', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
              const SizedBox(height: 8),
              GlassContainer(
                color: AppColors.cardDark,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _videoUrlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'https://...', hintStyle: TextStyle(color: Colors.white30)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Row(children: [Icon(Icons.info, color: AppColors.primary), SizedBox(width: 8), Text('General Details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),

              const SizedBox(height: 16),
              const Text('Donghua Title', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GlassContainer(
                color: AppColors.cardDark,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Enter title', hintStyle: TextStyle(color: Colors.white30)),
                     validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Episodes', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        GlassContainer(
                          color: AppColors.cardDark,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: _episodesController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: Colors.white30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rating', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        GlassContainer(
                          color: AppColors.cardDark,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: _ratingController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(border: InputBorder.none, hintText: '0.0', hintStyle: TextStyle(color: Colors.white30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Release Status', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: ['Ongoing', 'Completed', 'Upcoming'].map((s) {
                    final isSelected = _status == s;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _status = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(s, style: TextStyle(color: isSelected ? Colors.white : AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),
              const Text('Synopsis', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GlassContainer(
                color: AppColors.cardDark,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _descController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Tell us about the plot...', hintStyle: TextStyle(color: Colors.white30)),
                  ),
                ),
              ),

              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.backgroundDark,
        padding: const EdgeInsets.all(16),
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GradientButton(
              text: 'Save Donghua',
              icon: Icons.save,
              onPressed: _save,
            ),
      ),
    );
  }
}
