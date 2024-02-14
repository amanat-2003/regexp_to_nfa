import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:graphview/GraphView.dart';
import 'package:lottie/lottie.dart';
import 'package:regexp_to_nfa/re_to_nfa.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

class NFADiagramScreen extends StatefulWidget {
  const NFADiagramScreen({super.key});

  @override
  _NFADiagramScreenState createState() => _NFADiagramScreenState();
}

class _NFADiagramScreenState extends State<NFADiagramScreen> {
  final controller = TextEditingController();

  NFA? result;

  double size = 50;

  final Graph graph = Graph();

  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 20);

  bool isConverted = false;

  Future<void> _launchUrl(String url) async {
    final Uri urll = Uri.parse(url);
    if (!await launchUrl(urll)) {
      throw Exception('Could not launch $urll');
    }
  }

  List<Edge> edgeList = [];
  Set<Node> nodesSet = {};

  void clearGraph() {
    // graph.removeNodes(nodesSet.toList());
    // graph.removeEdges(edgeList);
    // setState(() {
    //   isConverted = false;
    //   result = null;
    //   stateId = 0;
    //   inputId = 0;
    // });
    html.window.location.reload();
  }

  void makeGraph() {
    try {
      final originalExpression = controller.text.trim();
      final postFixExpression = infixToPostfix(originalExpression);
      debugPrint("postFixExpression = $postFixExpression");

      // final List<Node> nodeList = [];

      // for (StateNode stateNode in result.allStatesList) {
      //   nodeList.add(Node.Id(stateNode.id));
      // }

      result = solvePostfixExpression(postFixExpression);

      for (StateNode stateNode in result!.allStatesList) {
        for (Transition trans in stateNode.transitions) {
          // graph.addEdge(
          //   Node.Id(stateNode.id),
          //   Node.Id(trans.nextState.id),
          //   title: trans.input.stringVal,
          //   paint: Paint()
          //     ..color = trans.input == a
          //         ? Colors.green
          //         : (trans.input == b ? Colors.red : Colors.blue)
          //     ..strokeWidth = 2
          //     ..style = PaintingStyle.stroke,
          // );
          nodesSet.add(Node.Id(stateNode.id));
          nodesSet.add(Node.Id(trans.nextState.id));
          edgeList.add(Edge(
            Node.Id(stateNode.id),
            Node.Id(trans.nextState.id),
            title: trans.input.stringVal,
            paint: Paint()
              ..color = trans.input == a
                  ? Colors.green
                  : (trans.input == b ? Colors.red : Colors.blue)
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
          ));
        }
      }

      graph.addEdges(edgeList);

      builder
        ..nodeSeparation = (100)
        ..levelSeparation = (50)
        ..orientation = SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT;

      setState(() {
        isConverted = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  DataTable TransitionTable() {
    Map<StateNode, Map<Input, List<StateNode>>> resultTable = {};
    List<DataRow> dataRows = [];

    resultTable = result!.generateTransitionTable();

    // print(resultTable);

    for (var state in result!.allStatesList) {
      Map<Input, String> outputs = {};
      for (var inp in inputs) {
        String outputStates = "";
        print(resultTable[state]![inp]);
        // resultTable[state]![inp]!.map((e) {
        //   print(e.stringVal);
        //   outputStates += "${e.stringVal} ";
        // });

        for (var outputState in resultTable[state]![inp]!) {
          // print(outputState.stringVal);
          outputStates += "${outputState.stringVal} ";
          // print(outputStates);
        }

        // print(outputStates);
        outputs[inp] = outputStates;
      }
      dataRows.add(DataRow(cells: [
        DataCell(Text(state.stringVal)),
        DataCell(Text(outputs[a]!)),
        DataCell(Text(outputs[b]!)),
        DataCell(Text(outputs[epsilon]!)),
      ]));
    }

    return DataTable(
      horizontalMargin: 100,
      columnSpacing: 100,
      border: TableBorder.all(),
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => const Color.fromARGB(86, 244, 67, 54)),
      columns: const [
        DataColumn(
          label: Text('Inputs\nStates'),
        ),
        DataColumn(
          label: Text('a'),
        ),
        DataColumn(
          label: Text('b'),
        ),
        DataColumn(
          label: Text('ε or e'),
        ),
      ],
      rows: dataRows,
    );
  }

  void increaseSize() {
    setState(() {
      if (builder.getNodeSeparation() >= 150 ||
          builder.getLevelSeparation() >= 150 ||
          size >= 100) {
      } else {
        builder.nodeSeparation += 10;
        builder.levelSeparation += 10;
        size += 5;
      }
    });
  }

  void decreaseSize() {
    setState(() {
      if (builder.getNodeSeparation() <= 20 ||
          builder.getLevelSeparation() <= 20 ||
          size <= 20) {
      } else {
        builder.nodeSeparation -= 10;
        builder.levelSeparation -= 10;
        size -= 5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var originalExp = 'a.(a+b)*.b';

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 50),
                const Text('Regular Expressions to NFA'),
                const Spacer(),
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'a*.(b+a*).(a.b)'),
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: isConverted ? clearGraph : makeGraph,
                  child: isConverted
                      ? const Text('Clear')
                      : const Text('Make NFA'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 50),
          const Text(
            "Size",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          IconButton(onPressed: decreaseSize, icon: const Icon(Icons.remove)),
          const SizedBox(width: 10),
          IconButton(onPressed: increaseSize, icon: const Icon(Icons.add)),
          const SizedBox(width: 50),
        ],
      ),
      body: isConverted? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            isConverted ? TransitionTable() : const SizedBox(),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 500,
                  maxWidth: screenWidth * 0.9,
                ),
                child: isConverted
                    ? Row(
                        children: [
                          Expanded(
                            child: InteractiveViewer(
                                constrained: false,
                                boundaryMargin: const EdgeInsets.all(100),
                                // minScale: 0.0001,
                                // maxScale: 10.6,
                                // scaleFactor: 1.0,
                                interactionEndFrictionCoefficient: 1.00,
                                alignment: Alignment.center,
                                trackpadScrollCausesScale: false,
                                // onInteractionStart: (details) {},
                                // panEnabled: false,
                                scaleEnabled: false,
                                child: Center(
                                  child: GraphView(
                                    graph: graph,
                                    algorithm: SugiyamaAlgorithm(builder),
                                    paint: Paint()
                                      ..color = Colors.green
                                      ..strokeWidth = 2
                                      ..style = PaintingStyle.stroke,
                                    builder: (Node node) {
                                      // I can decide what widget should be shown here based on the id
                                      var a = node.key!.value as int?;
                                      return rectangleWidget(a, size);
                                    },
                                  ),
                                )),
                          ),
                          DataTable(
                            // horizontalMargin: 100,
                            // columnSpacing: 100,
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    const Color.fromARGB(86, 244, 67, 54)),
                            columns: const [
                              DataColumn(
                                label: Text('Arrow Colour'),
                              ),
                              DataColumn(
                                label: Text('Inputs'),
                              ),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    color: Colors.green,
                                  ),
                                ),
                                const DataCell(Text('a')),
                              ]),
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    color: Colors.red,
                                  ),
                                ),
                                const DataCell(Text('b')),
                              ]),
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    color: Colors.blue,
                                  ),
                                ),
                                const DataCell(Text('ε')),
                              ]),
                            ],
                          )
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ):Center(child: Lottie.asset('assets/police.json')),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.0, // Adjust this value for the desired spacing
            children: [
              FlutterSocialButton(
                onTap: () {
                  _launchUrl("https://github.com/amanat-2003/regexp_to_nfa");
                },
                buttonType: ButtonType.github,
                mini: true,
              ),
              FlutterSocialButton(
                onTap: () {
                  _launchUrl("https://www.linkedin.com/in/amanat-coder/");
                },
                buttonType: ButtonType.linkedin,
                mini: true,
              ),
              ElevatedButton(
                onPressed: () {
                  _launchUrl("https://amanatsingh.tech");
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: googleColor,
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(
                  FontAwesomeIcons.globe,
                  color: Colors.white,
                ),
              ),
              FlutterSocialButton(
                onTap: () {
                  _launchUrl("https://twitter.com/AmanatSinghPU");
                },
                buttonType: ButtonType.twitter,
                mini: true,
              ),
              FlutterSocialButton(
                onTap: () {
                  _launchUrl(
                      "https://www.facebook.com/profile.php?id=61555527376075");
                },
                buttonType: ButtonType.facebook,
                mini: true,
              ),
              FlutterSocialButton(
                onTap: () {
                  _launchUrl(
                      "https://play.google.com/store/apps/details?id=com.anamiapps.appcolorpicker");
                },
                buttonType: ButtonType.phone,
                mini: true,
              ),
              FlutterSocialButton(
                onTap: () {
                  _launchUrl("mailto: amanatsinghnain@gmail.com");
                },
                buttonType: ButtonType.email,
                mini: true,
              ),
              const SizedBox(width: 30),
              InkWell(
                onTap: () {
                  _launchUrl("https://www.anamihub.com/");
                },
                child: const Text(
                  "For business queries visit our website",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget rectangleWidget(int? a, double size) {
    // return Container(
    //     padding: const EdgeInsets.all(16),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(4),
    //       boxShadow: [
    //         BoxShadow(color: Colors.blue.shade100, spreadRadius: 1),
    //       ],
    //     ),
    //     child: Text('$a'));
    return Container(
      width: size, // Adjust the width as needed
      height: size, // Adjust the height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 2.0, // Adjust the width of the border as needed
        ),
      ),
      // You can put child widgets inside the container if required
      child: Center(child: Text('$a')),
    );
  }
}
