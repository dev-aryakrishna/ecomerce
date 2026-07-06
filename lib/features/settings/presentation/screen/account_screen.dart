import 'package:ecomerceapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';
import 'package:ecomerceapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecomerceapp/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecomerceapp/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/router/route_names.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isEditing = false;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileEntity profile) {
    _nameController.text = profile.fullName;
    _phoneController.text = profile.phoneNumber;
  }


  String _resolveMessage(AppLocalizations l10n, String key) {
    switch (key) {
      case 'errorNetwork':
        return l10n.errorNetwork;
      case 'errorUnknown':
        return l10n.errorUnknown;
      case 'fullNameRequired':
        return l10n.fullNameRequired;
      case 'profileLoadFailed':
        return l10n.profileLoadFailed;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(ProfileLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.account),
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final isSaving = state is ProfileUpdating;
                return IconButton(
                  icon: Icon(_isEditing ? Icons.check : Icons.edit),
                  onPressed:
                      isSaving ? null : () => setState(() => _isEditing = !_isEditing),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push(RouteNames.settings),
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  context.go(RouteNames.login);
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdateSuccess) {
                  setState(() => _isEditing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.profileUpdated)),
                  );
                } else if (state is ProfileNoChanges) {
                  setState(() => _isEditing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.noChangesToSave)),
                  );
                } else if (state is ProfileUpdateFailure) {
                  // Keep the fields showing the last known-good values
                  // rather than whatever half-typed input caused the
                  // failure, so the screen never looks broken.
                  _syncControllers(state.profile);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_resolveMessage(l10n, state.messageKey)),
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoadFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _resolveMessage(l10n, state.messageKey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<ProfileBloc>()
                              .add(ProfileLoadRequested()),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final profile = _profileOf(state);
              if (profile == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final isSaving = state is ProfileUpdating;

              if (!_isEditing) {
                _syncControllers(profile);
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? TextFormField(
                          controller: _nameController,
                          enabled: !isSaving,
                          decoration: InputDecoration(
                            labelText: l10n.fullName,
                            border: const OutlineInputBorder(),
                          ),
                        )
                      : ListTile(
                          leading: const Icon(Icons.person_2_outlined),
                          title: Text(l10n.fullName),
                          subtitle: Text(
                            profile.fullName.isEmpty
                                ? l10n.notAvailable
                                : profile.fullName,
                          ),
                        ),
                  const SizedBox(height: 16),
                 
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(l10n.email),
                    subtitle: Text(
                      profile.email.isEmpty ? l10n.notAvailable : profile.email,
                    ),
                    trailing: _isEditing
                        ? Tooltip(
                            message: l10n.emailCannotBeChanged,
                            child: const Icon(Icons.lock_outline, size: 18),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? TextFormField(
                          controller: _phoneController,
                          enabled: !isSaving,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: l10n.phoneNumber,
                            hintText: l10n.phoneNumberOptionalHint,
                            border: const OutlineInputBorder(),
                          ),
                        )
                      : ListTile(
                          leading: const Icon(Icons.phone_outlined),
                          title: Text(l10n.phoneNumber),
                          subtitle: Text(
                            profile.phoneNumber.isEmpty
                                ? l10n.notAvailable
                                : profile.phoneNumber,
                          ),
                        ),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              context.read<ProfileBloc>().add(
                                    ProfileUpdateRequested(
                                      fullName: _nameController.text,
                                      phoneNumber: _phoneController.text,
                                    ),
                                  );
                            },
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.saveChanges),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  ProfileEntity? _profileOf(ProfileState state) {
    if (state is ProfileLoaded) return state.profile;
    if (state is ProfileUpdating) return state.profile;
    if (state is ProfileUpdateSuccess) return state.profile;
    if (state is ProfileNoChanges) return state.profile;
    if (state is ProfileUpdateFailure) return state.profile;
    return null;
  }
}
