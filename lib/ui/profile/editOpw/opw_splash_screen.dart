import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/profile/editOpw/create_profile_opw.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';

class OpwSplashScreen extends StatefulWidget {
  const OpwSplashScreen({super.key});

  static const String route = '/OpwSplashScreen';

  @override
  _OpwSplashScreenState createState() => _OpwSplashScreenState();
}

class _OpwSplashScreenState extends State<OpwSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToCreateProfile() async {
    if (_isNavigating) return; 
    _isNavigating = true;
    
    final store = StoreProvider.of<AppState>(context);
    final authState = store.state.authState;
    
    if (authState.isAuthenticated && 
        authState.setProfileCompleted && 
        authState.currentUserId.isNotEmpty &&
        ProjectConfig.appType == AppType.opw) {
      store.dispatch(LoadEvents());
      RoutingRules.defaultEntityLoadingRouting();
      return;
    }
    
    String? email;
    if (authState.emailLinkAuthEmail.isNotEmpty) {
      email = authState.emailLinkAuthEmail;
    } else if (authState.email.isNotEmpty) {
      email = authState.email;
    }
    
    if (email != null && email.isNotEmpty) {
      if (!store.state.isLoading) {
        store.dispatch(CheckExistingProfileByEmailRequest(
          email: email,
          context: context,
        ));
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CreateProfileOpw(),
          ),
        );
      }
    }
    
    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/opw/logo.png',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Open',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 52,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'world',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 52,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF007AFF),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.15),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: const Text(
                                        'BETA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: GestureDetector(
                                onTap: _navigateToCreateProfile,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
