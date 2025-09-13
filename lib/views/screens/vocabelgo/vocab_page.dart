import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:prufcoach/controller/vocabel_go_controller.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/widgets/vocabel_go_widget.dart';

class VokabelGoPage extends StatefulWidget {
  const VokabelGoPage({Key? key}) : super(key: key);

  @override
  State<VokabelGoPage> createState() => _VokabelGoPageState();
}

class _VokabelGoPageState extends State<VokabelGoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _languages = ["Englisch", "Russisch", "Arabisch"];
  Map<String, dynamic> _data = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languages.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData(_languages[0]);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // only when a tab is actually selected
      _loadData(_languages[_tabController.index]);
    }
  }

  Future<void> _loadData(String language) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Map<String, dynamic> loaded = await VocabService.loadVocab(
        language,
      );
      setState(() {
        _data = loaded;
      });
    } catch (e) {
      // handle error, e.g. show a message or empty
      setState(() {
        _data = {};
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.018,
        backgroundColor: AppColors.lightBackground,
        title: const Text(
          "VokabelGo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          // Intro text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              "Die wichtigsten Wörter für dein B1 – einfach & schnell lernen!",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ButtonsTabBar
          ButtonsTabBar(
            height: 60,
            controller: _tabController,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.75),
            unselectedBackgroundColor: AppColors.primaryGreen,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderWidth: 0.0,
            radius: 8,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            tabs:
                _languages.map((lang) {
                  return Tab(
                    child: SizedBox(
                      height: 50,
                      width:
                          MediaQuery.of(context).size.width *
                          0.7 /
                          _languages.length,
                      child: Center(
                        child: Text(
                          lang,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                      controller: _tabController,
                      children:
                          _languages.map((lang) {
                            if (_data.isEmpty) {
                              return const Center(
                                child: Text("Keine Wörter vorhanden"),
                              );
                            } else {
                              return ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 12.0,
                                ),
                                children:
                                    _data.entries.map((entry) {
                                      return Card(
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: VocabTopicTile(
                                          topic: entry.key,
                                          vocabMap:
                                              entry.value
                                                  as Map<String, dynamic>,
                                        ),
                                      );
                                    }).toList(),
                              );
                            }
                          }).toList(),
                    ),
          ),
        ],
      ),
    );
  }
}
