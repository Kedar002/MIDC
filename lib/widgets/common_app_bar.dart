import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final bool showEditButton;
  final bool isEditing;
  final VoidCallback? onEditToggle;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final VoidCallback? onPinToggle;
  final bool isPinned;
  final ValueChanged<String>? onSearchChanged;
  final bool showSearch;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.showEditButton = true,
    this.isEditing = false,
    this.onEditToggle,
    this.onSave,
    this.onCancel,
    this.onPinToggle,
    this.isPinned = false,
    this.onSearchChanged,
    this.showSearch = true,
  });

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Text(widget.title, style: AppTextStyles.h5),
          if (widget.showSearch) ...[
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Container(
                height: AppSpacing.inputHeight,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: AppColors.textSecondary,
                      size: AppSpacing.iconMd,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconSm,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              widget.onSearchChanged?.call('');
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  onChanged: (value) {
                    widget.onSearchChanged?.call(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (widget.showEditButton) ...[
          if (!widget.isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: widget.onEditToggle,
              tooltip: 'Edit',
            ),
          if (widget.isEditing) ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onCancel,
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: widget.onSave,
              tooltip: 'Save',
            ),
          ],
        ],
        if (widget.onPinToggle != null) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: Icon(widget.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: widget.onPinToggle,
            tooltip: widget.isPinned ? 'Unpin sidebar' : 'Pin sidebar',
          ),
        ],
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}
