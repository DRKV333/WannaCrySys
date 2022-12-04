import 'package:caff_parser/providers/caff_provider.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:caff_parser/widgets/bordered_text_field.dart';
import 'package:caff_parser/widgets/circular_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCaffScreen extends StatefulWidget {
  const EditCaffScreen({Key? key}) : super(key: key);

  @override
  State<EditCaffScreen> createState() => _EditCaffScreenState();
}

class _EditCaffScreenState extends State<EditCaffScreen> {
  final GlobalKey<FormState> _addCaffFormKey = GlobalKey();

  late TextEditingController _titleController;

  PlatformFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  Future<void> _chooseFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withReadStream: true, withData: true);

    if (result != null) {
      if (result.files.first.extension == 'caff') {
        setState(() {
          _pickedFile = result.files.first;
        });
      } else {
        Globals.showMessage('Only CAFF files are accepted', true);
      }
    }
  }

  void _navigateBack() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Edit CAFF'),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Form(
            key: _addCaffFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BorderedTextField(
                      _titleController,
                      'Title',
                      TextInputType.text,
                      validateFun: Globals.validateTitle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _pickedFile != null
                            ? Text(_pickedFile!.name)
                            : const SizedBox(),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 3,
                          ),
                          child: ElevatedButton(
                            onPressed: _chooseFile,
                            child: const Text('Choose file'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Consumer<CaffProvider>(
                  builder: (_, caffProvider, __) => CircularButton(
                    isLoading: caffProvider.isLoading,
                    text: 'Edit',
                    onPressed: () async {
                      if (_addCaffFormKey.currentState?.validate() ?? false) {
                        bool success = await caffProvider.editCaff(
                          caffProvider.caffId,
                          _pickedFile,
                          _titleController.text,
                        );
                        if (success) {
                          _navigateBack();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
