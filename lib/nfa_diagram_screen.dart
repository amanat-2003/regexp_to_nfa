import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:graphview/GraphView.dart';
import 'package:regexp_to_nfa/re_to_nfa.dart';
import 'package:url_launcher/url_launcher.dart';

class NFADiagramScreen extends StatefulWidget {
  @override
  _NFADiagramScreenState createState() => _NFADiagramScreenState();
}

class _NFADiagramScreenState extends State<NFADiagramScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var originalExp = 'a.(a+b)*.b';

    Future<void> _launchUrl(String url) async {
      final Uri urll = Uri.parse(url);
      if (!await launchUrl(urll)) {
        throw Exception('Could not launch $urll');
      }
    }

    void makeGraph() {
      try {
        final originalExpression = controller.text.trim();
        final postFixExpression = infixToPostfix(originalExpression);
        debugPrint("postFixExpression = $postFixExpression");

        NFA result = solvePostfixExpression(postFixExpression);

        final transitionTable = result.generateTransitionTable();

        // final List<Node> nodeList = [];

        // for (StateNode stateNode in result.allStatesList) {
        //   nodeList.add(Node.Id(stateNode.id));
        // }

        for (StateNode stateNode in result.allStatesList) {
          for (Transition trans in stateNode.transitions) {
            graph.addEdge(Node.Id(stateNode.id), Node.Id(trans.nextState.id),
                title: trans.input.stringVal);
          }
        }

        builder
          ..nodeSeparation = (100)
          ..levelSeparation = (50)
          ..orientation = SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT;

        setState(() {
          isGraphInitialized = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 600,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText:
                            'Type a Regular Expression(only use inputs a, b, e and operators as .?*+|)'),
                    controller: controller,
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: makeGraph,
                  child: const Text('Make NFA'),
                )
              ],
            ),
            Expanded(
              child: isGraphInitialized
                  ? InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.0001,
                      maxScale: 10.6,
                      trackpadScrollCausesScale: true,
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
                          return rectangleWidget(a);
                        },
                      ))
                  : const SizedBox(),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16.0, // Adjust this value for the desired spacing
              children: [
                FlutterSocialButton(
                  onTap: () {
                    // _launchUrl();
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
                    style: const TextStyle(
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
        ));
  }

  Random r = Random();

  Widget rectangleWidget(int? a) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue.shade100, spreadRadius: 1),
          ],
        ),
        child: Text('$a'));
  }

  final Graph graph = Graph();

  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 20);

  bool isGraphInitialized = false;
}
