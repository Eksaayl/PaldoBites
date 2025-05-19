import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoadingScreen extends StatelessWidget {
  final List<String> imageAssets = [
    'assets/images/resto1.jpg', 
    'assets/images/resto2.jpg', 
    'assets/images/resto3.jpg', 
    'assets/images/resto4.jpg', 
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final collageHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF5EE),
      body: Center(
        child: Container(
          color: const Color(0xFFFEF5EE),
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 500,
            minHeight: 800,
            maxHeight: 950,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    height: collageHeight,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(24),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(imageAssets[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Flexible(
                                child: Container(
                                  height: 130,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(24),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(imageAssets[1]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 400,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      bottomLeft: Radius.circular(24),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(imageAssets[2]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Paldo',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Bites',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover the best restaurant and food around you',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60.4),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          child: Image.asset(
                            imageAssets[3],
                            width: 300,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          elevation: 0,
                          fillColor: Colors.black,
                          shape: const CircleBorder(),
                          constraints: const BoxConstraints.tightFor(
                            width: 56,
                            height: 56,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 