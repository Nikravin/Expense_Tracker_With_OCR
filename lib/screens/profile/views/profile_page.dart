import 'package:expense_tracker/screens/authentication/bloc/user_bloc.dart';
import 'package:expense_tracker/screens/authentication/view/user_login.dart';
import 'package:expense_tracker/screens/profile/bloc/app_theme/app_theme_bloc.dart';
import 'package:expense_tracker/screens/profile/bloc/profile_bloc.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:expense_tracker/services/currency_service.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redacted/redacted.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();

  static Widget withBloc() {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileData()),
      child: const ProfilePage(),
    );
  }
}

class ProfilePageState extends State<ProfilePage> {
  // bool _notificationsEnabled = true;
  // bool _biometricEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      appBar: Appbar(title: "Profile"),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(state),
                  SizedBox(height: 30),

                  // Quick Stats
                  _buildQuickStats(state),
                  SizedBox(height: 30),

                  // Settings Sections
                  _buildSettingsSection(),
                  SizedBox(height: 20),

                  // Account Management
                  _buildAccountSection(),
                  SizedBox(height: 20),

                  // Support & Info
                  _buildSupportSection(),
                  SizedBox(height: 30),

                  // Logout Button
                  _buildLogoutButton(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileState state) {
    if (state is ProfileLoading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor(
                    context,
                  ).withOpacity(0.1),
                ).redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    redactedColor: Colors.grey[60],
                    defaultBorderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "example",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                redactedColor: Colors.grey[60],
                defaultBorderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "example@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                redactedColor: Colors.grey[60],
                defaultBorderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Text(
                'Premium Member',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is ProfileError) {
      return Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Error loading profile',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    String username = 'User';
    String email = 'No email';
    String initials = 'U';

    if (state is ProfileLoaded) {
      username = state.username;
      email = state.email;
      initials = username.isNotEmpty
          ? username
                .split(' ')
                .map((name) => name[0])
                .take(2)
                .join()
                .toUpperCase()
          : 'U';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor(
                  context,
                ).withOpacity(0.1),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor(context),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            username,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(email, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Text(
              'Premium Member',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ProfileState state) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '₹';
        if (currencyState is CurrencyLoaded) {
          currencySymbol = currencyState.currentCurrency.symbol;
        }

        if (state is ProfileLoading) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 15),
                // Total Balance Card (Full Width)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor(context),
                        AppTheme.secondaryColor(context),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.wallet,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$currencySymbol 0000000',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).redacted(
                        context: context,
                        redact: true,
                        configuration: RedactedConfiguration(
                          redactedColor: Colors.grey[60],
                          defaultBorderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child:
                          _buildStatCard(
                            'Total Income',
                            '$currencySymbol 0000000',
                            Colors.green,
                            Icons.trending_up,
                          ).redacted(
                            context: context,
                            redact: true,
                            configuration: RedactedConfiguration(
                              redactedColor: Colors.grey[60],
                              defaultBorderRadius: BorderRadius.circular(10),
                            ),
                          ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        'Total Expenses',
                        '$currencySymbol 00000000',
                        Colors.red,
                        Icons.trending_down,
                      ),
                    ).redacted(
                      context: context,
                      redact: true,
                      configuration: RedactedConfiguration(
                        redactedColor: Colors.grey[60],
                        defaultBorderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        double totalBalance = 0.0;
        double incomeBalance = 0.0;
        double expenseBalance = 0.0;

        if (state is ProfileLoaded) {
          totalBalance = state.totalBalance;
          incomeBalance = state.incomeBalance;
          expenseBalance = state.expenseBalance;
        }

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15),
              // Total Balance Card (Full Width)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor(context),
                      AppTheme.secondaryColor(context),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.wallet,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$currencySymbol${totalBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Income',
                      '$currencySymbol${incomeBalance.toStringAsFixed(2)}',
                      Colors.green,
                      Icons.trending_up,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Total Expenses',
                      '$currencySymbol${expenseBalance.abs().toStringAsFixed(2)}',
                      Colors.red,
                      Icons.trending_down,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // _buildSettingsTile(
          //   icon: FontAwesomeIcons.bell,
          //   title: 'Notifications',
          //   subtitle: 'Get notified about your expenses',
          //   trailing: Switch(
          //     value: _notificationsEnabled,
          //     onChanged: (value) {
          //       setState(() {
          //         _notificationsEnabled = value;
          //       });
          //     },
          //     activeColor: Colors.deepPurple[600],
          //   ),
          // ),
          // _buildSettingsTile(
          //   icon: FontAwesomeIcons.fingerprint,
          //   title: 'Biometric Login',
          //   subtitle: 'Use fingerprint or face ID',
          //   trailing: Switch(
          //     value: _biometricEnabled,
          //     onChanged: (value) {
          //       setState(() {
          //         _biometricEnabled = value;
          //       });
          //     },
          //     activeColor: Colors.deepPurple[600],
          //   ),
          // ),
          BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (context, state) {
              String currentCurrency = 'USD';
              if (state is CurrencyLoaded) {
                currentCurrency = state.currentCurrency.code;
              }
              return _buildSettingsTile(
                icon: FontAwesomeIcons.dollarSign,
                title: 'Currency',
                subtitle: currentCurrency,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () => _showCurrencyPicker(),
              );
            },
          ),
          BlocBuilder<AppThemeBloc, AppThemeState>(
            builder: (context, state) {
              bool isDarkTheme = state is AppThemeLoadedState
                  ? state.isDark
                  : false;
              return _buildSettingsTile(
                icon: FontAwesomeIcons.palette,
                title: 'Theme',
                subtitle: isDarkTheme ? 'Dark' : 'Light',
                trailing: Switch(
                  value: isDarkTheme,
                  onChanged: (value) {
                    context.read<AppThemeBloc>().add(
                      ChangeAppTheme(isDark: value),
                    );
                  },
                  activeColor: Colors.deepPurple[600],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Account Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildSettingsTile(
            icon: FontAwesomeIcons.cloudArrowDown,
            title: 'Export Data',
            subtitle: 'Download your transaction history',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
          _buildSettingsTile(
            icon: FontAwesomeIcons.creditCard,
            title: 'Subscription',
            subtitle: 'Manage your premium subscription',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Support & Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildSettingsTile(
            icon: FontAwesomeIcons.headset,
            title: 'Help & Support',
            subtitle: 'Get help with the app',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
          _buildSettingsTile(
            icon: FontAwesomeIcons.star,
            title: 'Rate App',
            subtitle: 'Rate us on the app store',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
          _buildSettingsTile(
            icon: FontAwesomeIcons.circleInfo,
            title: 'About',
            subtitle: 'App version 2.1.0',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: Colors.deepPurple[600]),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[600],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.red[200]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.rightFromBracket, size: 18),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    final currencyBloc = BlocProvider.of<CurrencyBloc>(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: currencyBloc,
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Currency',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: BlocBuilder<CurrencyBloc, CurrencyState>(
                        builder: (context, state) {
                          String selectedCode = 'USD';
                          if (state is CurrencyLoaded) {
                            selectedCode = state.currentCurrency.code;
                          }

                          return ListView.builder(
                            controller: scrollController,
                            itemCount:
                                CurrencyService.supportedCurrencies.length,
                            itemBuilder: (context, index) {
                              final currency =
                                  CurrencyService.supportedCurrencies[index];
                              final isSelected = currency.code == selectedCode;
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryColor(
                                          context,
                                        ).withOpacity(0.1)
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected
                                      ? Border.all(
                                          color: AppTheme.primaryColor(context),
                                        )
                                      : null,
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor(
                                        context,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      currency.symbol,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor(context),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${currency.code} - ${currency.name}',
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppTheme.primaryColor(context)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          color: AppTheme.primaryColor(context),
                                        )
                                      : null,
                                  onTap: () {
                                    context.read<CurrencyBloc>().add(
                                      ChangeCurrency(currency),
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Currency changed to ${currency.name}',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => UserLogoutBloc(),
          child: BlocConsumer<UserLogoutBloc, UserState>(
            listener: (context, state) {
              if (state is UserSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserLogin()),
                );
              } else if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text('Logout'),
                content: Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserLogoutBloc>().add(UserLogoutRequest());
                      // Handle logout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Logout'),
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
