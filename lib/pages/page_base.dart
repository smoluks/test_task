import 'dart:async';

import 'package:flutter/material.dart';

abstract class PageBase<T extends StatefulWidget> extends State<T> {
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await onInitPage();
      } catch (e) {
        setStateError(e.toString());
      }
    });
  }

  //--stubs for override--
  Future<void> onInitPage() async {
    setStateOk();
  }

  Future<void> onClosePage() async {}

  Widget view(BuildContext context);

  //--page change--
  Future<R?> goToNextPage<R>(StatefulWidget page) async {
    await onClosePage();

    if (!mounted) return null;
    var result = await Navigator.of(context)
        .push(MaterialPageRoute<R>(builder: (context) {
      return page;
    }));

    return result;
  }

  Future goBack(Object? result) async {
    await onClosePage();

    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  //--page state--
  void setStateLoading({String? text}) {
    setState(() {
      loading = true;
    });
  }

  void setStateNoLoading() {
    setState(() {
      loading = false;
    });
  }

  void setStateOk() {
    setState(() {
      loading = false;
      error = null;
    });
  }

  void setStateError(String ex) {
    setState(() {
      loading = false;
      error = ex;
    });
  }

  //--common views--
  @override
  Widget build(BuildContext context) {
    if (loading) return _getLoadingWidget();
    if (error != null) return _getErrorWidget();

    return Scaffold(appBar: null, body: view(context));
  }

  Widget _getLoadingWidget() {
    return Scaffold(
        appBar: null,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
              SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator()),
              Text(
                "Loading...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.red),
              )
            ])));
  }

  Widget _getErrorWidget() {
    return Scaffold(
        appBar: null,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.red),
              )
            ])));
  }

  //--wrappers for event handlers--
  bool isProcessing = false;
  Future<void> Function() onAction(Future<void> Function() action) {
    Future<void> innerFunction() async {
      if (isProcessing) return;
      if (loading) return;

      isProcessing = true;

      try {
        await action();
      } catch (e) {
        setStateError(e.toString());
      } finally {
        isProcessing = false;
      }
    }

    return innerFunction;
  }

  //for callback using
  Future<void> Function() onActionWithParam<Q>(
      Future<void> Function(Q) action, Q param) {
    Future<void> innerFunction() async {
      if (isProcessing) return;
      if (loading) return;

      isProcessing = true;

      try {
        await action(param);
      } catch (e) {
        setStateError(e.toString());
      } finally {
        isProcessing = false;
      }
    }

    return innerFunction;
  }

  //for immediately call
  Future<void> processActionWithParam<Q>(
      Future<void> Function(Q) action, Q param) async {
    if (isProcessing) return;
    if (loading) return;

    isProcessing = true;

    try {
      await action(param);
    } catch (e) {
      setStateError(e.toString());
    } finally {
      isProcessing = false;
    }
  }
}
