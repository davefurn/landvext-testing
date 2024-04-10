import 'package:flutter/material.dart';
import 'package:landvext/src/core/constants/imports.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    required this.child,
    required this.items,
    required this.onChange,
    Key? key,
    this.hideIcon = false,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
  }) : super(key: key);
  final Widget child;
  final void Function(T, int) onChange;
  final List<DropdownItem<T>> items;
  final DropdownStyle dropdownStyle;
  final DropdownButtonStyle dropdownButtonStyle;
  final Icon? icon;
  final bool hideIcon;
  final bool leadingIcon;

  @override
  CustomDropdownState<T> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  late LayerLink _layerLink;
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _layerLink = LayerLink();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle;
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: style.width ?? 100, // Provide default width if not set
        height: style.height ?? 40, // Provide default height if not set
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: style.padding ?? EdgeInsets.zero,
            backgroundColor: style.backgroundColor,
            elevation: style.elevation,
            shape: style.shape,
            foregroundColor: style.backgroundColor,
            shadowColor: style.shadowColor,
            surfaceTintColor: LandColors.backgroundColour,
          ),
          onPressed: _toggleDropdown,
          child: Row(
            mainAxisAlignment: style.mainAxisAlignment ??
                MainAxisAlignment.spaceBetween, //edited
            textDirection:
                widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentIndex == -1) ...[
                widget.child,
              ] else ...[
                widget.items[_currentIndex],
              ],
              if (!widget.hideIcon)
                RotationTransition(
                  turns: _rotateAnimation,
                  child: widget.icon ??
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: LandColors.textColorVeryBlack,
                        size: 22.sp,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var size = renderBox?.size ?? Size.zero;
    var offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset:
                      widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle.elevation ?? 0,
                    borderRadius:
                        widget.dropdownStyle.borderRadius ?? BorderRadius.zero,
                    color: widget.dropdownStyle.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding:
                              widget.dropdownStyle.padding ?? EdgeInsets.zero,
                          shrinkWrap: true,
                          children: widget.items
                              .asMap()
                              .entries
                              .map(
                                (item) => InkWell(
                                  onTap: () {
                                    setState(() => _currentIndex = item.key);
                                    widget.onChange(
                                      item.value.value,
                                      item.key,
                                    );
                                    _toggleDropdown();
                                  },
                                  child: item.value,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() => _isOpen = true);
      await _animationController.forward();
    }
  }
}

class DropdownItem<T> extends StatelessWidget {
  const DropdownItem({required this.value, required this.child, Key? key})
      : super(key: key);
  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class DropdownButtonStyle {
  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
    this.foregroundColor,
    this.shadowColor,
  });
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;
  final Color? foregroundColor;
  final Color? shadowColor;
}

class DropdownStyle {
  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Offset? offset;
  final double? width;
}
