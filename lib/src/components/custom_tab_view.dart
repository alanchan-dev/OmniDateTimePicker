import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  final TabController controller;
  final List<Widget> children;

  const CustomTabView({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late int index;

  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation1;
  late final Animation<Offset> _offsetAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    index = _controller.index;
    _controller.addListener(_controllerListener);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: index.toDouble(),
    );

    _offsetAnimation1 = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _offsetAnimation2 = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _animationController.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (_controller.indexIsChanging) {
      setState(() {
        index = _controller.index;
      });
      if (_controller.previousIndex == 0 && index == 1) {
        _animationController.forward();
      } else if (_controller.previousIndex == 1 && index == 0) {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: index == 1 ? _offsetAnimation1 : _offsetAnimation2,
      child: IndexedStack(
        index: index,
        children: widget.children,
      ),
    );
  }
}
