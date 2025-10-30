import 'dart:async';
import 'package:flutter/material.dart';
import 'package:caf_sdk/caf_sdk.dart';
import 'package:caf_sdk/types/index.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAF SDK Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CafSdkExamplePage(),
    );
  }
}

class CafSdkExamplePage extends StatefulWidget {
  const CafSdkExamplePage({super.key});

  @override
  State<CafSdkExamplePage> createState() => _CafSdkExamplePageState();
}

class _CafSdkExamplePageState extends State<CafSdkExamplePage> {
  final _cafSdk = CafSdk();
  final List<Map<String, dynamic>> _events = [];
  StreamSubscription? _eventSubscription;

  final String _mobileToken = "token";
  final String _personId = "personId";
  final CafEnvironment _environment = CafEnvironment.dev;

  // Modules
  bool _useDocumentDetector = true;
  bool _useDocumentDetectorUI = false;
  bool _useFaceLiveness = true;
  bool _useFaceLivenessUI = false;

  @override
  void initState() {
    super.initState();
    _initializeEventStream();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _initializeEventStream() {
    _eventSubscription = _cafSdk.eventStream.listen((event) {
      if (!mounted) return;

      setState(() {
        _events.add({
          'eventName': event['eventName'],
          'response': event['response'].toString(),
        });
      });
    });
  }

  Future<void> _initializeCafSdk() async {
    try {
      // This creates the list of modules based on the selections made in the user interface.
      // You must pass the modules sequentially in the presentationOrder field,
      // which represents the order in which they will be executed by the SDK.
      //  * You cannot use two versions of the same module simultaneously;
      //    choose whether to use the SDK's user interface components or not.
      //  * Do not submit the same module more than once.
      final List<CafModuleType> presentationOrder = [];
      if (_useDocumentDetector) {
        presentationOrder.add(CafModuleType.documentDetector);
      }
      if (_useDocumentDetectorUI) {
        presentationOrder.add(CafModuleType.documentDetectorUi);
      }
      if (_useFaceLiveness) {
        presentationOrder.add(CafModuleType.faceLiveness);
      }
      if (_useFaceLivenessUI) {
        presentationOrder.add(CafModuleType.faceLivenessUi);
      }

      if (presentationOrder.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one module to initialize.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // SDK Configuration
      final config = CafSdkConfiguration(
        mobileToken: _mobileToken,
        personId: _personId,
        environment: _environment,
        configuration: CafSdkBuilderConfiguration(
          presentationOrder: presentationOrder,
          waitForAllServices: true,
        ),
      );

      // Document Detector Configuration (if enabled)
      CafDocumentDetectorConfiguration? documentDetectorConfig;
      if (_useDocumentDetector) {
        documentDetectorConfig = CafDocumentDetectorConfiguration(
          configuration: CafDocumentDetectorBuilderConfiguration(
            flow: [
              CafDocumentDetectorFlow(document: CafDocument.rgFront),
              CafDocumentDetectorFlow(document: CafDocument.rgBack),
            ],
            uploadSettings: CafDocumentDetectorUploadSettings(enable: false),
            manualCaptureEnabled: false,
            manualCaptureTime: 45,
            showPopup: true,
            previewShow: false,
            securitySettings: CafDocumentDetectorSecuritySettings(
              useAdb: true,
              useDebug: true,
              useDevelopmentMode: true,
            ),
          ),
        );
      }

      // Document Detector UI Configuration (if enabled)
      CafDocumentDetectorUIConfiguration? documentDetectorUIConfig;
      if (_useDocumentDetectorUI) {
        documentDetectorUIConfig = CafDocumentDetectorUIConfiguration(
          configuration: CafDocumentDetectorBuilderConfiguration(
            flow: [
              CafDocumentDetectorFlow(document: CafDocument.rgFront),
              CafDocumentDetectorFlow(document: CafDocument.rgBack),
              CafDocumentDetectorFlow(document: CafDocument.rgFull),
              CafDocumentDetectorFlow(document: CafDocument.cnhFront),
              CafDocumentDetectorFlow(document: CafDocument.cnhBack),
              CafDocumentDetectorFlow(document: CafDocument.cnhFull),
              CafDocumentDetectorFlow(document: CafDocument.crlv),
              CafDocumentDetectorFlow(document: CafDocument.rneFront),
              CafDocumentDetectorFlow(document: CafDocument.rneBack),
              CafDocumentDetectorFlow(document: CafDocument.ctpsFront),
              CafDocumentDetectorFlow(document: CafDocument.ctpsBack),
              CafDocumentDetectorFlow(document: CafDocument.passport),
              CafDocumentDetectorFlow(document: CafDocument.any),
            ],
            uploadSettings: CafDocumentDetectorUploadSettings(enable: true),
            manualCaptureEnabled: false,
            manualCaptureTime: 45,
            showPopup: true,
            previewShow: false,
            securitySettings: CafDocumentDetectorSecuritySettings(
              useAdb: true,
              useDebug: true,
              useDevelopmentMode: true,
            ),
          ),
          instructionScreenConfiguration:
              CafDocumentDetectorUIBuilderInstructionScreenConfiguration(
                enable: true,
                captureSteps: ["Capture Step 1", "Capture Step 2"],
                uploadTitle: "Upload Title",
                uploadSteps: ["Upload Step 1", "Upload Step 2"],
                description: "Description",
                buttonText: "Button Text",
              ),
          documentSelectionScreenConfiguration:
              CafDocumentDetectorUIBuilderDocumentSelectionScreenConfiguration(
                title: "Document Selection Title",
                description: "Document Selection Description",
              ),
        );
      }

      // Face Liveness Configuration (if enabled)
      CafFaceLivenessConfiguration? faceLivenessConfig;
      if (_useFaceLiveness) {
        faceLivenessConfig = CafFaceLivenessConfiguration(
          configuration: CafFaceLivenessBuilderConfiguration(
            loading: true,
            debugModeEnabled: true,
          ),
        );
      }

      // Face Liveness UI Configuration (if enabled)
      CafFaceLivenessUIConfiguration? faceLivenessUIConfig;
      if (_useFaceLivenessUI) {
        faceLivenessUIConfig = CafFaceLivenessUIConfiguration(
          configuration: CafFaceLivenessBuilderConfiguration(
            loading: true,
            debugModeEnabled: true,
          ),
          instructionScreenConfiguration:
              CafFaceLivenessUIBuilderInstructionScreenConfiguration(
                title: "Face Liveness",
                description:
                    "Position your face in the center and follow the instructions",
                steps: [
                  "Center your face",
                  "Follow the instructions",
                  "Stay still",
                ],
                buttonText: "Start",
              ),
        );
      }

      await _cafSdk.initializeCafSdk(
        cafSdkConfiguration: config,
        documentDetectorConfiguration: documentDetectorConfig,
        documentDetectorUIConfiguration: documentDetectorUIConfig,
        faceLivenessConfiguration: faceLivenessConfig,
        faceLivenessUIConfiguration: faceLivenessUIConfig,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CAF SDK initialized successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _clearEvents() {
    if (!mounted) return;
    setState(() {
      _events.clear();
    });
  }

  Widget _buildModuleSelector() {
    final List<Map<String, dynamic>> modules = [
      {
        'name': 'Document Detector',
        'enabled': _useDocumentDetector,
        'onToggle': () =>
            setState(() => _useDocumentDetector = !_useDocumentDetector),
      },
      {
        'name': 'Document Detector UI',
        'enabled': _useDocumentDetectorUI,
        'onToggle': () =>
            setState(() => _useDocumentDetectorUI = !_useDocumentDetectorUI),
      },
      {
        'name': 'Face Liveness',
        'enabled': _useFaceLiveness,
        'onToggle': () => setState(() => _useFaceLiveness = !_useFaceLiveness),
      },
      {
        'name': 'Face Liveness UI',
        'enabled': _useFaceLivenessUI,
        'onToggle': () =>
            setState(() => _useFaceLivenessUI = !_useFaceLivenessUI),
      },
    ];

    final enabledCount = modules
        .where((module) => module['enabled'] as bool)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Modules', style: Theme.of(context).textTheme.titleLarge),
                Row(
                  children: [
                    TextButton(
                      onPressed: _enableAllModules,
                      child: const Text('Enable All'),
                    ),
                    TextButton(
                      onPressed: _disableAllModules,
                      child: const Text('Disable All'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select the modules you want to use in your CAF SDK configuration.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...modules.asMap().entries.map((entry) {
              final index = entry.key;
              final module = entry.value;
              final isEnabled = module['enabled'] as bool;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isEnabled ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        module['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: isEnabled ? null : Colors.grey[600],
                          fontWeight: isEnabled
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Switch(
                      value: isEnabled,
                      onChanged: (_) => module['onToggle'](),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Enabled modules: $enabledCount/${modules.length}',
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enableAllModules() {
    setState(() {
      _useDocumentDetector = true;
      _useDocumentDetectorUI = true;
      _useFaceLiveness = true;
      _useFaceLivenessUI = true;
    });
  }

  void _disableAllModules() {
    setState(() {
      _useDocumentDetector = false;
      _useDocumentDetectorUI = false;
      _useFaceLiveness = false;
      _useFaceLivenessUI = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAF SDK Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ConfigurationCard(mobileToken: _mobileToken, personId: _personId, environment: _environment),
            const SizedBox(height: 16),

            _buildModuleSelector(),
            const SizedBox(height: 16),

            _ActionButtons(
              onInitialize: _initializeCafSdk,
              onClearEvents: _clearEvents,
            ),
            const SizedBox(height: 16),

            _EventsCard(events: _events),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _ConfigurationCard extends StatelessWidget {
  const _ConfigurationCard({required this.mobileToken, required this.personId, required this.environment});

  final String mobileToken;
  final String personId;
  final CafEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CAF SDK Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Mobile Token: ${mobileToken.length > 20 ? '${mobileToken.substring(0, 20)}...' : mobileToken}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Person ID: $personId',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Environment: $environment',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onInitialize,
    required this.onClearEvents,
  });

  final VoidCallback onInitialize;
  final VoidCallback onClearEvents;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onInitialize,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Initialize SDK'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onClearEvents,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear Events'),
          ),
        ),
      ],
    );
  }
}

class _EventsCard extends StatelessWidget {
  const _EventsCard({required this.events});

  final List<Map<String, dynamic>> events;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events (${events.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: events.isEmpty
                  ? const Center(
                      child: Text(
                        'No events yet',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: events.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final event = events[events.length - 1 - index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        event['eventName'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  event['response'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
