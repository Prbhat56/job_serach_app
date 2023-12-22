import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodspace_assignment/constant/utilis.dart';
import 'package:goodspace_assignment/data_model/job_data_model.dart';
import 'package:goodspace_assignment/data_model/profile_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Job>> _jobsFuture;
  @override
  void initState() {
    super.initState();
    _jobsFuture = _fetchJobs();
  }

  Future<List<Job>> _fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString('auth_token') ?? '';
    const String apiUrl =
        'https://api.ourgoodspace.com/api/d2/member/dashboard/feed';
    final headers = {
      'Authorization': authToken,
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jobsJson = json.decode(response.body)['data'];

      List<dynamic> jobEntries = jobsJson
          .where((entry) => entry['type'] == 'JOB' && entry['cardData'] != null)
          .toList();
      List<Job> jobs = jobEntries
          .map((entry) =>
              Job.fromJson(entry['cardData'] as Map<String, dynamic>))
          .toList();
      return jobs;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 300;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40 * fem,
                  height: 40 * fem,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * fem),
                      border: Border.all(color: Color(0xffffffff)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/6.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 195,
                ),
                Image.asset(
                  'assets/7.png',
                  width: 22.28 * fem,
                  height: 20.15 * fem,
                ),
                SizedBox(
                  width: 7,
                ),
                Image.asset(
                  'assets/8.png',
                  width: 20.83 * fem,
                  height: 22.91 * fem,
                ),
                SizedBox(
                  width: 7,
                ),
                Image.asset(
                  'assets/9.png',
                  width: 20.83 * fem,
                  height: 14.58 * fem,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/7.png',
                  width: 15.48 * fem,
                  height: 14 * fem,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(
                  'Step into the future',
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.5 * ffem / fem,
                    color: Color(0xba000000),
                  ),
                ),
              ],
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  var profile1 = profiles[index];
                  return Container(
                      width: 160,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              profile1.imagePath,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            profile1.name,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.2 * ffem / fem,
                              color: Color(0xba000000),
                            ),
                          ),
                          Text(
                            profile1.role,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 12 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.2000000477 * ffem / fem,
                              color: Color(0xff297bc9),
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
            Container(
              height: 2,
              color: Colors.blue,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "jobs for you",
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2000000477 * ffem / fem,
                    color: Color(0xff297bc9),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 2,
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Jobs',
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<Job>>(
                future: _jobsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<Job> jobs = snapshot.data!;
                    return ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        Job job = jobs[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        job.title,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 18 * ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2000000212 * ffem / fem,
                                          color: Color(0xff070f1b),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      job.relativeTime,
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 11 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2000000694 * ffem / fem,
                                        color: Color(0xff6d6e71),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 16, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text(
                                      job.locationCity,
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2000000477 * ffem / fem,
                                        color: Color(0xff6d6e71),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Divider(),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildInfoChip(job.displayCompensation,
                                        Icons.monetization_on),
                                    _buildInfoChip(
                                        "${job.lowerworkex}-${job.upperworkex} Years",
                                        Icons.work),
                                    if (job.isRemote)
                                      _buildInfoChip('Remote', Icons.home_work,
                                          backgroundColor: Colors.blue,
                                          textColor: Colors.white),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(job.imageUrl),
                                      radius: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        job.name,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 12 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2000000477 * ffem / fem,
                                          color: Color(0xff6d6e71),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // investorctaDkD (1:6475)
                                      width: 120 * fem,
                                      height: 35 * fem,
                                      decoration: BoxDecoration(
                                        color: Color(0xff389fff),
                                        borderRadius:
                                            BorderRadius.circular(3 * fem),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Apply',
                                          style: SafeGoogleFont(
                                            'Inter',
                                            fontSize: 16 * ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.0625 * ffem / fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No jobs found'));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon,
      {Color? backgroundColor, Color? textColor}) {
    double baseWidth = 300;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Chip(
      avatar: Icon(icon, size: 18, color: textColor ?? Colors.blue),
      label: Text(
        text,
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 11 * ffem,
          fontWeight: FontWeight.w400,
          height: 1.2000000694 * ffem / fem,
          color: Color(0xff1d9915),
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
