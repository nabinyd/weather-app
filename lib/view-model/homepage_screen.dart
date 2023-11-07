// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:weatherapi/api/api_service.dart';
import 'package:weatherapi/api/state_city.dart';
import 'package:weatherapi/model/cities_model.dart';
import 'package:weatherapi/model/country_state_model.dart' as cs_model;

class HomePagescreen extends StatefulWidget {
  HomePagescreen({super.key, this.position});
  String? position = '';
  @override
  State<HomePagescreen> createState() => _HomePagescreenState();
}

class _HomePagescreenState extends State<HomePagescreen> {
/* --------------------------- country state city --------------------------- */
  final CountryStateCityRepo _countryStateCityRepo = CountryStateCityRepo();

  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];
  cs_model.CountryStateModel countryStateModel =
      cs_model.CountryStateModel(error: false, msg: '', data: []);

  CitiesModel citiesModel = CitiesModel(error: false, msg: '', data: []);

  String selectedCountry = 'Select Country';
  String selectedState = 'Select State';
  String selectedCity = 'Select City';
  bool isDataLoaded = false;

  String finalTextToBeDisplayed = '';

  getCountries() async {
    //
    countryStateModel = await _countryStateCityRepo.getCountriesStates();
    countries.add('Select Country');
    states.add('Select State');
    cities.add('Select City');
    for (var element in countryStateModel.data) {
      countries.add(element.name);
    }
    isDataLoaded = true;
    setState(() {});
    //
  }

  getStates() async {
    //
    for (var element in countryStateModel.data) {
      if (selectedCountry == element.name) {
        //
        setState(() {
          resetStates();
          resetCities();
        });
        //
        for (var state in element.states) {
          states.add(state.name);
        }
      }
    }
    //
  }

  getCities() async {
    //
    isDataLoaded = false;
    citiesModel = await _countryStateCityRepo.getCities(
        country: selectedCountry, state: selectedState);
    setState(() {
      resetCities();
    });
    for (var city in citiesModel.data) {
      cities.add(city);
    }
    isDataLoaded = true;
    setState(() {});
    //
  }

  resetCities() {
    cities = [];
    cities.add('Select City');
    selectedCity = 'Select City';
    finalTextToBeDisplayed = '';
  }

  resetStates() {
    states = [];
    states.add('Select State');
    selectedState = 'Select State';
    finalTextToBeDisplayed = '';
  }

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Country State City'),
        centerTitle: true,
      ),
      body: Center(
        child: !isDataLoaded
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton(
                        isExpanded: true,
                        value: selectedCountry,
                        items: countries
                            .map((String country) => DropdownMenuItem(
                                value: country, child: Text(country)))
                            .toList(),
                        onChanged: (selectedValue) {
                          //
                          setState(() {
                            selectedCountry = selectedValue!;
                          });
                          // In Video we have used getStates();
                          // getStates();
                          // But for improvement we can use one extra check
                          if (selectedCountry != 'Select Country') {
                            getStates();
                          }
                          //
                        }),
                    const SizedBox(height: 20),
                    DropdownButton(
                        isExpanded: true,
                        value: selectedState,
                        items: states
                            .map((String state) => DropdownMenuItem(
                                value: state, child: Text(state)))
                            .toList(),
                        onChanged: (selectedValue) {
                          //
                          setState(() {
                            selectedState = selectedValue!;
                          });
                          if (selectedState != 'Select State') {
                            getCities();
                          }
                          //
                        }),
                    const SizedBox(height: 20),
                    DropdownButton(
                        isExpanded: true,
                        value: selectedCity,
                        items: cities
                            .map((String city) => DropdownMenuItem(
                                value: city, child: Text(city)))
                            .toList(),
                        onChanged: (selectedValue) {
                          //
                          setState(() {
                            selectedCity = selectedValue!;
                          });
                          if (selectedCity != 'Select City') {
                            finalTextToBeDisplayed =
                                "Country: $selectedCountry\nState: $selectedState\nCity: $selectedCity";
                          }
                          //
                        }),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blueAccent),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            print(finalTextToBeDisplayed);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApiService(
                                      location: selectedCity,
                                      country: selectedCountry,
                                      state: selectedState),
                                ));
                          },
                          child: const Text(
                            'show weather',
                            style: TextStyle(fontSize: 18, letterSpacing: .8),
                          )),
                    ),
                    const Positioned(
                        bottom: 0,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [Text('Cpoyright Ⓒ by Nabin Yadav')],
                        ))
                  ],
                )),
      ),
    );
  }
}
