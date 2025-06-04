import 'package:fluo/fluo.dart';
import 'package:fluo/fluo_onboarding.dart';
import 'package:fluo/l10n/fluo_localizations.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        // Important: add this one
        FluoLocalizations.delegate,
        // ...other delegates...
      ],
      home: FluoOnboarding(
        apiKey: 'GTDVrEkA2GvPrbsuxM43JVSzVrIISIGYT5hGNvZLozA=',
        onUserReady: (fluo) async {
          // 1. Initialize the Supabase client somewhere in your code
          // 2. Use 'recoverSession' as below:
          await Supabase.instance.client.auth
              .recoverSession(fluo.supabaseSession!);
        },
      ),
    );
  }
}
