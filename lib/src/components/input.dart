import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/src/components/disabled.dart';
import 'package:shadcn_ui/src/theme/components/decorator.dart';
import 'package:shadcn_ui/src/theme/theme.dart';

class ShadInput extends StatefulWidget {
  const ShadInput({
    super.key,
    this.initialValue,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.decoration,
    this.undoController,
    this.inputDecoration = const InputDecoration(),
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    this.dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapOutside,
    this.mouseCursor,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration = TextMagnifierConfiguration.disabled,
    this.selectionColor,
    this.padding,
    this.border,
    this.radius,
  })  : smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        enableInteractiveSelection =
            enableInteractiveSelection ?? (!readOnly || !obscureText),
        assert(
          initialValue == null || controller == null,
          'Either initialValue or controller must be specified',
        );

  final ShadDecoration? decoration;

  final String? initialValue;

  final Widget? placeholder;

  final TextMagnifierConfiguration magnifierConfiguration;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final InputDecoration? inputDecoration;

  final TextInputType keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final TextStyle? style;

  final StrutStyle? strutStyle;

  final TextAlign textAlign;

  final TextAlignVertical? textAlignVertical;

  final TextDirection? textDirection;

  final bool autofocus;

  final String obscuringCharacter;

  final bool obscureText;

  final bool autocorrect;

  final SmartDashesType smartDashesType;

  final SmartQuotesType smartQuotesType;

  final bool enableSuggestions;

  final int? maxLines;

  final int? minLines;

  final bool expands;

  final bool readOnly;

  final bool? showCursor;

  static const int noMaxLength = -1;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final List<TextInputFormatter>? inputFormatters;

  final bool enabled;

  final double cursorWidth;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final bool? cursorOpacityAnimates;

  final Color? cursorColor;

  final ui.BoxHeightStyle selectionHeightStyle;

  final ui.BoxWidthStyle selectionWidthStyle;

  final Brightness? keyboardAppearance;

  final EdgeInsets scrollPadding;

  final bool enableInteractiveSelection;

  final TextSelectionControls? selectionControls;

  final DragStartBehavior dragStartBehavior;

  bool get selectionEnabled => enableInteractiveSelection;

  final GestureTapCallback? onTap;

  final TapRegionCallback? onTapOutside;

  final MouseCursor? mouseCursor;

  final ScrollPhysics? scrollPhysics;

  final ScrollController? scrollController;

  final Iterable<String>? autofillHints;

  final Clip clipBehavior;

  final String? restorationId;

  final bool scribbleEnabled;

  final bool enableIMEPersonalizedLearning;

  final ContentInsertionConfiguration? contentInsertionConfiguration;

  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final UndoHistoryController? undoController;

  final SpellCheckConfiguration? spellCheckConfiguration;

  final Color? selectionColor;

  final EdgeInsets? padding;
  final Border? border;
  final BorderRadius? radius;

  @override
  State<ShadInput> createState() => ShadInputState();
}

class ShadInputState extends State<ShadInput>
    implements TextSelectionGestureDetectorBuilderDelegate {
  // ignore: use_late_for_private_fields_and_variables
  FocusNode? _focusNode;
  FocusNode get focusNode => widget.focusNode ?? _focusNode!;
  final hasFocus = ValueNotifier(false);
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _focusNode = FocusNode();
    focusNode.addListener(onFocusChange);
    controller = widget.controller ??
        TextEditingController.fromValue(
          TextEditingValue(text: widget.initialValue ?? ''),
        );
  }

  @override
  void didUpdateWidget(ShadInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(onFocusChange);
      focusNode.addListener(onFocusChange);
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);

    if (widget.focusNode == null) focusNode.dispose();
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  void onFocusChange() {
    hasFocus.value = focusNode.hasFocus;
  }

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  late final _selectionGestureDetectorBuilder =
      _InputSelectionGestureDetectorBuilder(state: this);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final effectiveTextStyle = widget.style ??
        theme.textTheme.muted.copyWith(
          color: theme.colorScheme.foreground,
        );
    final effectiveDecoration =
        widget.decoration ?? theme.inputTheme.decoration ?? theme.decoration;
    final effectivePadding = widget.padding ??
        theme.inputTheme.padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    final effectiveBorder = widget.border ??
        theme.inputTheme.border ??
        Border.all(
          color: theme.colorScheme.border,
          width: 2,
        );
    final effectiveRadius =
        widget.radius ?? theme.inputTheme.radius ?? theme.radius;

    return ShadDisabled(
      disabled: !widget.enabled,
      child: ValueListenableBuilder(
        valueListenable: hasFocus,
        builder: (context, focused, _) {
          return ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, textEditingValue, child) {
              return ShadDecorator(
                decoration: effectiveDecoration,
                focused: focused,
                isEmpty: textEditingValue.text.isEmpty,
                placeholder: Padding(
                  padding: EdgeInsets.only(
                    top: effectivePadding.top + effectiveBorder.top.width,
                    left: effectivePadding.left + effectiveBorder.left.width,
                  ),
                  child: widget.placeholder,
                ),
                child: child!,
              );
            },
            child: Container(
              padding: effectivePadding,
              decoration: BoxDecoration(
                border: effectiveBorder,
                borderRadius: effectiveRadius,
              ),
              child: _selectionGestureDetectorBuilder.buildGestureDetector(
                behavior: HitTestBehavior.translucent,
                child: EditableText(
                  key: editableTextKey,
                  controller: controller,
                  focusNode: focusNode,
                  style: effectiveTextStyle,
                  cursorColor: widget.cursorColor ?? theme.colorScheme.primary,
                  backgroundCursorColor: Colors.grey,
                  selectionColor: focused
                      ? widget.selectionColor ?? theme.colorScheme.selection
                      : null,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  autofocus: widget.autofocus,
                  obscureText: widget.obscureText,
                  autocorrect: widget.autocorrect,
                  magnifierConfiguration: widget.magnifierConfiguration,
                  smartDashesType: widget.smartDashesType,
                  smartQuotesType: widget.smartQuotesType,
                  enableSuggestions: widget.enableSuggestions,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  expands: widget.expands,
                  onChanged: widget.onChanged,
                  onEditingComplete: widget.onEditingComplete,
                  onSubmitted: widget.onSubmitted,
                  onAppPrivateCommand: widget.onAppPrivateCommand,
                  inputFormatters: widget.inputFormatters,
                  cursorWidth: widget.cursorWidth,
                  cursorHeight: widget.cursorHeight,
                  cursorRadius: widget.cursorRadius,
                  selectionHeightStyle: widget.selectionHeightStyle,
                  selectionWidthStyle: widget.selectionWidthStyle,
                  scrollPadding: widget.scrollPadding,
                  dragStartBehavior: widget.dragStartBehavior,
                  scrollController: widget.scrollController,
                  scrollPhysics: widget.scrollPhysics,
                  autofillHints: widget.autofillHints,
                  clipBehavior: widget.clipBehavior,
                  restorationId: widget.restorationId,
                  scribbleEnabled: widget.scribbleEnabled,
                  enableIMEPersonalizedLearning:
                      widget.enableIMEPersonalizedLearning,
                  contentInsertionConfiguration:
                      widget.contentInsertionConfiguration,
                  contextMenuBuilder: widget.contextMenuBuilder,
                  selectionControls: widget.selectionControls,
                  mouseCursor: widget.mouseCursor,
                  enableInteractiveSelection: widget.enableInteractiveSelection,
                  undoController: widget.undoController,
                  spellCheckConfiguration: widget.spellCheckConfiguration,
                  onTapOutside: widget.onTapOutside,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get forcePressEnabled {
    return switch (Theme.of(context).platform) {
      TargetPlatform.iOS => true,
      _ => false,
    };
  }

  @override
  bool get selectionEnabled => widget.enableInteractiveSelection;
}

class _InputSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _InputSelectionGestureDetectorBuilder({
    required ShadInputState state,
  })  : _state = state,
        super(delegate: state);

  final ShadInputState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    super.onSingleLongTapStart(details);
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          Feedback.forLongPress(_state.context);
      }
    }
  }
}
