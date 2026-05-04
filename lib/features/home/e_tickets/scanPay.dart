import 'package:e_shuttle/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class scanPay extends StatefulWidget {
  const scanPay({
    super.key,
    this.showAppBar = true,
  });

  final bool showAppBar;

  @override
  State<scanPay> createState() => _scanPayState();
}

class _scanPayState extends State<scanPay> {
  final String _qrData = "google"; // TODO: replace with backend-generated token

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveHelper.horizontalPadding(context);
    final maxWidth = ResponsiveHelper.maxContentWidth(context);
    final qrSize = ResponsiveHelper.qrSize(context);

    final titleSize = ResponsiveHelper.pageTitleSize(context);
    final sectionTitleSize = ResponsiveHelper.sectionTitleSize(context);
    final bodyTextSize = ResponsiveHelper.hintTextSize(context);

    final verticalPadding = ResponsiveHelper.value<double>(
      context,
      mobile: 24.0,
      tablet: 36.0,
      large: 48.0,
    );

    final titleGap = ResponsiveHelper.value<double>(
      context,
      mobile: 32.0,
      tablet: 48.0,
      large: 60.0,
    );

    final bottomGap = ResponsiveHelper.value<double>(
      context,
      mobile: 40.0,
      tablet: 60.0,
      large: 80.0,
    );

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('QR Code Generator'),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    minHeight: constraints.maxHeight - (verticalPadding * 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'E-Tickets',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: titleGap),

                      Text(
                        'Scan to Pay...!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sectionTitleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Validate your code at the bus entrance before and after your arrival to exit.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: bodyTextSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: _qrData,
                          version: QrVersions.auto,
                          size: qrSize,
                          backgroundColor: Colors.white,
                        ),
                      ),

                      SizedBox(height: bottomGap),

                      _ActionButtons(
                        onCheckBalance: () {
                          // TODO: navigate to wallet/balance page
                        },
                        onRecharge: () {
                          // TODO: navigate to recharge page
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onCheckBalance,
    required this.onRecharge,
  });

  final VoidCallback onCheckBalance;
  final VoidCallback onRecharge;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallWidth = constraints.maxWidth < 420;

        if (isSmallWidth) {
          return Column(
            children: [
              _ResponsiveButton(
                label: 'Check Balance',
                onPressed: onCheckBalance,
              ),
              const SizedBox(height: 14),
              _ResponsiveButton(
                label: 'Recharge',
                onPressed: onRecharge,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _ResponsiveButton(
                label: 'Check Balance',
                onPressed: onCheckBalance,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _ResponsiveButton(
                label: 'Recharge',
                onPressed: onRecharge,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ResponsiveButton extends StatelessWidget {
  const _ResponsiveButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = ResponsiveHelper.value<double>(
      context,
      mobile: 46.0,
      tablet: 52.0,
      large: 56.0,
    );

    final textSize = ResponsiveHelper.value<double>(
      context,
      mobile: 14.0,
      tablet: 16.0,
      large: 18.0,
    );

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}