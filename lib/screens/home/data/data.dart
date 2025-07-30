import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> myExpenseTransactionData = [
  {
    'icon': Icon(FontAwesomeIcons.house, color: Colors.grey),
    'name': 'House Rent',
  },
  {'icon': Icon(FontAwesomeIcons.home, color: Colors.grey), 'name': 'Mortgage'},
  {
    'icon': Icon(FontAwesomeIcons.lightbulb, color: Colors.grey),
    'name': 'Electricity Bill',
  },
  {
    'icon': Icon(FontAwesomeIcons.droplet, color: Colors.grey),
    'name': 'Water Bill',
  },
  {'icon': Icon(FontAwesomeIcons.fire, color: Colors.grey), 'name': 'Gas Bill'},
  {
    'icon': Icon(FontAwesomeIcons.wifi, color: Colors.grey),
    'name': 'Internet Bill',
  },
  {
    'icon': Icon(FontAwesomeIcons.phone, color: Colors.grey),
    'name': 'Phone Bill',
  },
  {
    'icon': Icon(FontAwesomeIcons.mobileAlt, color: Colors.grey),
    'name': 'Phone Bill',
  },
  {
    'icon': Icon(FontAwesomeIcons.hammer, color: Colors.grey),
    'name': 'House Maintenance',
  },
  {'icon': Icon(FontAwesomeIcons.utensils, color: Colors.grey), 'name': 'Food'},
  {
    'icon': Icon(FontAwesomeIcons.basketShopping, color: Colors.grey),
    'name': 'Groceries',
  },
  {
    'icon': Icon(FontAwesomeIcons.utensils, color: Colors.grey),
    'name': 'Dining Out',
  },
  {
    'icon': Icon(FontAwesomeIcons.coffee, color: Colors.grey),
    'name': 'Coffee / Snacks',
  },
  {
    'icon': Icon(FontAwesomeIcons.motorcycle, color: Colors.grey),
    'name': 'Food Delivery',
  },
  {'icon': Icon(FontAwesomeIcons.gasPump, color: Colors.grey), 'name': 'Fuel'},
  {
    'icon': Icon(FontAwesomeIcons.car, color: Colors.grey),
    'name': 'Car EMI Payment',
  },
  {
    'icon': Icon(FontAwesomeIcons.bus, color: Colors.grey),
    'name': 'Public Transport',
  },
  {
    'icon': Icon(FontAwesomeIcons.taxi, color: Colors.grey),
    'name': 'Ride Sharing',
  },
  {
    'icon': Icon(FontAwesomeIcons.squareParking, color: Colors.grey),
    'name': 'Parking',
  },
  {
    'icon': Icon(FontAwesomeIcons.screwdriverWrench, color: Colors.grey),
    'name': 'Car Maintenance',
  },
  {
    'icon': Icon(FontAwesomeIcons.shirt, color: Colors.grey),
    'name': 'Clothing',
  },
  {
    'icon': Icon(FontAwesomeIcons.scissors, color: Colors.grey),
    'name': 'Haircuts / Salons',
  },
  {
    'icon': Icon(FontAwesomeIcons.dumbbell, color: Colors.grey),
    'name': 'Gym / Fitness',
  },
  {
    'icon': Icon(FontAwesomeIcons.fileInvoiceDollar, color: Colors.grey),
    'name': 'Medical Bills',
  },
  {
    'icon': Icon(FontAwesomeIcons.shield, color: Colors.grey),
    'name': 'Insurance (Health / Life)',
  },
  {
    'icon': Icon(FontAwesomeIcons.pills, color: Colors.grey),
    'name': 'Medicine',
  },
  {
    'icon': Icon(FontAwesomeIcons.graduationCap, color: Colors.grey),
    'name': 'Tuition',
  },
  {
    'icon': Icon(FontAwesomeIcons.pen, color: Colors.grey),
    'name': 'School Supplies',
  },
  {'icon': Icon(FontAwesomeIcons.book, color: Colors.grey), 'name': 'Books'},
  {
    'icon': Icon(FontAwesomeIcons.laptop, color: Colors.grey),
    'name': 'Courses / Subscriptions',
  },
  {
    'icon': Icon(FontAwesomeIcons.tv, color: Colors.grey),
    'name': 'Streaming Services',
  },
  {'icon': Icon(FontAwesomeIcons.film, color: Colors.grey), 'name': 'Movies'},
  {'icon': Icon(FontAwesomeIcons.gamepad, color: Colors.grey), 'name': 'Games'},
  {
    'icon': Icon(FontAwesomeIcons.ticket, color: Colors.grey),
    'name': 'Events / Concerts',
  },
  {
    'icon': Icon(FontAwesomeIcons.baby, color: Colors.grey),
    'name': 'Childcare',
  },
  {
    'icon': Icon(FontAwesomeIcons.school, color: Colors.grey),
    'name': 'School Fees',
  },
  {
    'icon': Icon(FontAwesomeIcons.gamepad, color: Colors.grey),
    'name': 'Toys & Games',
  },
  {
    'icon': Icon(FontAwesomeIcons.childDress, color: Colors.grey),
    'name': 'Kids\' Clothing',
  },
  {
    'icon': Icon(FontAwesomeIcons.briefcase, color: Colors.grey),
    'name': 'Work Travel',
  },
  {
    'icon': Icon(FontAwesomeIcons.paperclip, color: Colors.grey),
    'name': 'Office Supplies',
  },
  {
    'icon': Icon(FontAwesomeIcons.crown, color: Colors.grey),
    'name': 'Subscriptions',
  },
  {
    'icon': Icon(FontAwesomeIcons.stapler, color: Colors.grey),
    'name': 'Office Supplies',
  },
  {
    'icon': Icon(FontAwesomeIcons.toolbox, color: Colors.grey),
    'name': 'Freelance Tools',
  },
  {
    'icon': Icon(FontAwesomeIcons.handHoldingDollar, color: Colors.grey),
    'name': 'Loan Payments',
  },
  {
    'icon': Icon(FontAwesomeIcons.moneyBillTransfer, color: Colors.grey),
    'name': 'EMI Payments',
  },
  {
    'icon': Icon(FontAwesomeIcons.creditCard, color: Colors.grey),
    'name': 'Credit Card Payments',
  },
  {
    'icon': Icon(FontAwesomeIcons.piggyBank, color: Colors.grey),
    'name': 'Savings',
  },
  {
    'icon': Icon(FontAwesomeIcons.chartLine, color: Colors.grey),
    'name': 'Investments',
  },
  {
    'icon': Icon(FontAwesomeIcons.wallet, color: Colors.grey),
    'name': 'Savings',
  },
  {
    'icon': Icon(FontAwesomeIcons.fileInvoice, color: Colors.grey),
    'name': 'Taxes',
  },
  {
    'icon': Icon(FontAwesomeIcons.building, color: Colors.grey),
    'name': 'Savings',
  },
  {
    'icon': Icon(FontAwesomeIcons.receipt, color: Colors.grey),
    'name': 'Bank Fees',
  },
  {'icon': Icon(FontAwesomeIcons.gift, color: Colors.grey), 'name': 'Gifts'},
  {
    'icon': Icon(FontAwesomeIcons.handHoldingHeart, color: Colors.grey),
    'name': 'Donations',
  },
  {'icon': Icon(FontAwesomeIcons.paw, color: Colors.grey), 'name': 'Pet Care'},
  {
    'icon': Icon(FontAwesomeIcons.ellipsis, color: Colors.grey),
    'name': 'Miscellaneous',
  },
  {
    'icon': Icon(FontAwesomeIcons.planeUp, color: Colors.grey),
    'name': 'Travel / Vacation',
  },
];

List<Map<String, dynamic>> myIncomeTransactionData = [
  {'icon': Icon(FontAwesomeIcons.wallet, color: Colors.grey), 'name': 'Salary'},
  {
    'icon': Icon(FontAwesomeIcons.building, color: Colors.grey),
    'name': 'Business Income',
  },
  {
    'icon': Icon(FontAwesomeIcons.laptop, color: Colors.grey),
    'name': 'Freelance / Contract Work',
  },
  {
    'icon': Icon(FontAwesomeIcons.chartPie, color: Colors.grey),
    'name': 'Dividends',
  },
  {
    'icon': Icon(FontAwesomeIcons.percent, color: Colors.grey),
    'name': 'Interest Income',
  },
  {
    'icon': Icon(FontAwesomeIcons.chartLine, color: Colors.grey),
    'name': 'Stock Market Gains',
  },
  {
    'icon': Icon(FontAwesomeIcons.houseChimney, color: Colors.grey),
    'name': 'Rental Income',
  },
  {
    'icon': Icon(FontAwesomeIcons.gift, color: Colors.grey),
    'name': 'Gifts Received',
  },
  {
    'icon': Icon(FontAwesomeIcons.dice, color: Colors.grey),
    'name': 'Lottery / Gambling Winnings',
  },
  {
    'icon': Icon(FontAwesomeIcons.arrowRotateLeft, color: Colors.grey),
    'name': 'Tax Refund',
  },
  {
    'icon': Icon(FontAwesomeIcons.userTie, color: Colors.grey),
    'name': 'Pension',
  },
  {
    'icon': Icon(FontAwesomeIcons.landmark, color: Colors.grey),
    'name': 'Government Assistance',
  },
  {
    'icon': Icon(FontAwesomeIcons.handHoldingDollar, color: Colors.grey),
    'name': 'Child Support',
  },
  {
    'icon': Icon(FontAwesomeIcons.scroll, color: Colors.grey),
    'name': 'Inheritance',
  },
  {
    'icon': Icon(FontAwesomeIcons.handHoldingDollar, color: Colors.grey),
    'name': 'Tips',
  },
  {
    'icon': Icon(FontAwesomeIcons.cashRegister, color: Colors.grey),
    'name': 'Cashback / Rewards',
  },
  {
    'icon': Icon(FontAwesomeIcons.hammer, color: Colors.grey),
    'name': 'Side Hustle',
  },
  {
    'icon': Icon(FontAwesomeIcons.cartShopping, color: Colors.grey),
    'name': 'Online Sales',
  },
  {
    'icon': Icon(FontAwesomeIcons.link, color: Colors.grey),
    'name': 'Affiliate Income',
  },
  {
    'icon': Icon(FontAwesomeIcons.chalkboardUser, color: Colors.grey),
    'name': 'Course / Coaching Revenue',
  },
  {
    'icon': Icon(FontAwesomeIcons.tags, color: Colors.grey),
    'name': 'Asset Sale',
  },
  {
    'icon': Icon(FontAwesomeIcons.receipt, color: Colors.grey),
    'name': 'Refunds / Returns',
  },
  {
    'icon': Icon(FontAwesomeIcons.moneyBillTransfer, color: Colors.grey),
    'name': 'Reimbursements',
  },
  {
    'icon': Icon(FontAwesomeIcons.ellipsis, color: Colors.grey),
    'name': 'Miscellaneous Income',
  },
];
