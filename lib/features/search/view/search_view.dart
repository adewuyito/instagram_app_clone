import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/search/view/widget/search_grid_widget.dart';
import 'package:instagram_app_clone/utils/constants/strings.dart';
import 'package:instagram_app_clone/utils/extentions/dismiss_keyboard.dart';

class SearchViewTab extends HookConsumerWidget {
  const SearchViewTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');

    useEffect(() {
      controller.addListener(() {
        searchTerm.value = controller.text;
      });

      return () {};
    }, [controller]);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: Strings.enterYourSearchTermHere,
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    controller.clear();
                    dismissKeyboard;
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: SearchGridView(
              searchTearm: searchTerm.value,
            ),
          ),
        ],
      ),
    );
  }
}
