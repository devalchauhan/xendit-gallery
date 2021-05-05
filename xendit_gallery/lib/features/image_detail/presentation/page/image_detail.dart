import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_detail/presentation/cubit/image_detail_cubit.dart';
import 'package:xendit_gallery/features/image_detail/presentation/widgets/image_detail_widgets.dart';

List _elements = [
  {'name': 'John', 'group': 'Downloaded'},
  {'name': 'Will', 'group': 'Downloaded'},
  {'name': 'Beth', 'group': 'Downloading'},
  {'name': 'Miranda', 'group': 'Downloading'},
  {'name': 'Mike', 'group': 'Downloading'},
  {'name': 'Danny', 'group': 'Downloading'},
];

class ImageDetail extends StatefulWidget {
  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  void initState() {
    BlocProvider.of<ImageDetailCubit>(context)
        .callGetImageDetailList(NoParams());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<ImageDetailCubit, ImageDetailState>(
        listener: (context, state) {},
        child: BlocBuilder<ImageDetailCubit, ImageDetailState>(
          builder: (BuildContext context, ImageDetailState imageListState) {
            if (imageListState is ImageDetailInitial) {
              return Center(child: CircularProgressIndicator());
            }
            if (imageListState is LoadedState) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GroupedListView<dynamic, String>(
                  elements: _elements,
                  groupBy: (element) => element['group'],
                  groupSeparatorBuilder: (String groupByValue) => SectionHeader(
                    groupByValue: groupByValue,
                  ),
                  separator: SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, dynamic element) => SectionRow(
                    element: element,
                  ),
                  itemComparator: (item1, item2) =>
                      item1['name'].compareTo(item2['name']), // optional
                  useStickyGroupSeparators: false, // optional
                  floatingHeader: true, // optional
                  order: GroupedListOrder.ASC, // optional
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
