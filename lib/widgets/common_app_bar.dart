import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
          Icon(widget.icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(widget.title),
          if (widget.showSearch) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue.withOpacity(0.7),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black.withOpacity(0.7),
                              size: 18,
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
                      horizontal: 12,
                      vertical: 10,
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
              icon: const Icon(Icons.edit),
              onPressed: widget.onEditToggle,
              tooltip: 'Edit',
            ),
          if (widget.isEditing) ...[
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: widget.onCancel,
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: widget.onSave,
              tooltip: 'Save',
            ),
          ],
        ],
        if (widget.onPinToggle != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(widget.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: widget.onPinToggle,
            tooltip: widget.isPinned ? 'Unpin sidebar' : 'Pin sidebar',
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }
}
