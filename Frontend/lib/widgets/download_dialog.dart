import 'package:caff_parser/providers/caff_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({Key? key}) : super(key: key);

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  @override
  void initState() {
    super.initState();

    _downloadCaff();
  }

  void _closeDialog() => Navigator.of(context).pop();

  Future<void> _downloadCaff() async {
    await Provider.of<CaffProvider>(context, listen: false).downloadCaff();
    _closeDialog();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            maxHeight: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Downloading ...'),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
}
