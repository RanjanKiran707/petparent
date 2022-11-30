import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petparent/data/repository/global_repository.dart';

import '../bloc/list_loader_bloc.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListLoaderBloc(GRepository()),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Posts List"),
          ),
          body: Builder(
            builder: (context) {
              return SizedBox.expand(
                child: BlocBuilder<ListLoaderBloc, ListLoaderState>(
                  builder: (context, state) {
                    if (state is ListLoaderInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ListLoaderDone) {
                      return ListView.builder(
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          final item = state.list[index];

                          return ListTile(
                            onTap: () {},
                            isThreeLine: true,
                            minVerticalPadding: 10,
                            title: Text(item["title"]),
                            subtitle: Text(item["body"]),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text((state as ListLoaderError).error),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
