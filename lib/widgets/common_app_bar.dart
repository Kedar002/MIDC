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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onSearchChanged?.call('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: widget.onSearchChanged,
            )
          : Row(
              children: [
                Icon(widget.icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(widget.title),
              ],
            ),
      actions: [
        if (widget.showSearch)
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Close search' : 'Search',
          ),
        if (!_isSearching && widget.showEditButton) ...[
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
        if (!_isSearching && widget.onPinToggle != null) ...[
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
