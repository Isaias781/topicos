import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rutina Personalizada',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final Widget child;
  final String imageUrl;

  const BackgroundImage({super.key, required this.child, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      imageUrl: 'https://www.blogdelfotografo.com/wp-content/uploads/2021/12/Fondo_Negro_3.webp',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _navigateToGoalPage(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final int age = int.parse(_ageController.text);
      final double height = double.parse(_heightController.text);
      final double weight = double.parse(_weightController.text);

      if (height <= 50 || weight <= 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Los valores ingresados no parecen realistas.')),
        );
        return;
      }

      final double bmi = weight / pow(height / 100, 2);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalPage(
            name: name,
            age: age,
            height: height,
            weight: weight,
            bmi: bmi,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inicio de Sesión',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              fillColor: Colors.white,
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu nombre.';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Edad',
              fillColor: Colors.white,
              filled: true,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu edad.';
              }
              final num? parsedValue = num.tryParse(value);
              if (parsedValue == null || parsedValue <= 0) {
                return 'Por favor, ingresa una edad válida.';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Estatura (cm)',
              fillColor: Colors.white,
              filled: true,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu estatura.';
              }
              final num? parsedValue = num.tryParse(value);
              if (parsedValue == null || parsedValue <= 0) {
                return 'Por favor, ingresa una estatura válida.';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              fillColor: Colors.white,
              filled: true,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu peso.';
              }
              final num? parsedValue = num.tryParse(value);
              if (parsedValue == null || parsedValue <= 0) {
                return 'Por favor, ingresa un peso válido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => _navigateToGoalPage(context),
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}

class GoalPage extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double weight;
  final double bmi;

  const GoalPage({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.bmi,
  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String? selectedLevel;
  final List<String> levels = ['Principiante', 'Intermedio', 'Avanzado'];

  void _navigateToRoutinePage(BuildContext context) {
    if (selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un nivel.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutinePage(level: selectedLevel!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      imageUrl: 'https://png.pngtree.com/thumb_back/fh260/background/20200714/pngtree-modern-double-color-futuristic-neon-background-image_351866.jpg',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${widget.name}! Tu IMC es ${widget.bmi.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Selecciona tu nivel'),
              items: levels.map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLevel = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToRoutinePage(context),
                child: const Text('Ver Rutina'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class RoutinePage extends StatelessWidget {
  final String level;

  const RoutinePage({super.key, required this.level});

  final Map<String, Map<String, List<Map<String, String>>>> routines = const {
    "Principiante": {
      "Lunes": [
        {
          "nombre": "Push-ups",
          "descripcion": "3 series de 8-10 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtBbIievUXmTC8NG5TrjLVjWMjymBZAtF3GQ&s"
        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 20 segundos, repite 3 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "Flexiones contra la pared",
          "descripcion": "3 series de 10 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgX1pJJ1uv49obE5z-7JRJsTep_WduZi-X-HCnPvPXfwV41Cza4WjekIPl-G3_EtcWsKs&usqp=CAU"
        },
        {
          "nombre": "Correr",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
      "Martes": [
        {
          "nombre": "Correr",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
        {
          "nombre": "Abdominales",
          "descripcion": "30 repeticiones, 3 veces.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHyDIAJrI_fkjj2Wg6XXLIgp6lhUm_XwmOvg&s"
        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 20 segundos, repite 3 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "Saltos de cuerda",
          "descripcion": "Duración de 15 minutos.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
      "Miércoles": [
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
        {
          'nombre': 'Sentadillas con peso',
          'descripcion': '4 series de 8 repeticiones.',
          'imagen': 'https://media.tenor.com/pdMmsiutWkcAAAAM/gym.gif',
        },
        {
          'nombre': 'Lunges saltando',
          'descripcion': '3 series de 10 repeticiones por pierna.',
          'imagen': 'https://media.tenor.com/7EIR-PckiQEAAAAM/lunge-split.gif',
        },
        {
          "nombre": "Estocadas",
          "descripcion": "3 series de 10 repeticiones por pierna.",
          "imagen": "https://media.tenor.com/sZ7VwZ6jrbcAAAAM/gym.gif"
        }
      ],
      "Jueves": [
        {
          "nombre": "Push-ups",
          "descripcion": "3 series de 8-10 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtBbIievUXmTC8NG5TrjLVjWMjymBZAtF3GQ&s"
        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 20 segundos, repite 3 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "Flexiones contra la pared",
          "descripcion": "3 series de 10 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgX1pJJ1uv49obE5z-7JRJsTep_WduZi-X-HCnPvPXfwV41Cza4WjekIPl-G3_EtcWsKs&usqp=CAU"
        },
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
      "Viernes": [
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
        {
          "nombre": "adominales",
          "descripcion": "30 repeticiones 3 veces",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHyDIAJrI_fkjj2Wg6XXLIgp6lhUm_XwmOvg&s"

        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 20 segundos, repite 3 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "saltos de cuerda ",
          "descripcion": "durar lo de 15 min.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
  },
    "Intermedio": {
      "Lunes": [
        {
          "nombre": "Push-ups",
          "descripcion": "5 series de 8-10 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtBbIievUXmTC8NG5TrjLVjWMjymBZAtF3GQ&s"
        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 1 min, repite 4 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "Flexiones contra la pared",
          "descripcion": "4 series de 30 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgX1pJJ1uv49obE5z-7JRJsTep_WduZi-X-HCnPvPXfwV41Cza4WjekIPl-G3_EtcWsKs&usqp=CAU"
        },
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
      "Martes": [
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
        {
          "nombre": "adominales",
          "descripcion": "30 repeticiones 5 veces",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHyDIAJrI_fkjj2Wg6XXLIgp6lhUm_XwmOvg&s"

        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 1 min, repite 4 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "saltos de cuerda ",
          "descripcion": "durar lo de 20 min.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
      "Miércoles": [
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
        {
          'nombre': 'Sentadillas con peso',
          'descripcion': '4 series de 8 repeticiones.',
          'imagen': 'https://media.tenor.com/pdMmsiutWkcAAAAM/gym.gif',
        },
        {
          'nombre': 'Lunges saltando',
          'descripcion': '4 series de 15 repeticiones por pierna.',
          'imagen': 'https://media.tenor.com/7EIR-PckiQEAAAAM/lunge-split.gif',
        },
        {
          "nombre": "Estocadas",
          "descripcion": "4 series de 15 repeticiones por pierna.",
          "imagen": "https://media.tenor.com/sZ7VwZ6jrbcAAAAM/gym.gif"
        }
      ],
      "Jueves": [
        {
          "nombre": "Push-ups",
          "descripcion": "5 series de 8-10 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtBbIievUXmTC8NG5TrjLVjWMjymBZAtF3GQ&s"
        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 1 min, repite 4 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "Flexiones contra la pared",
          "descripcion": "4 series de 30 repeticiones.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgX1pJJ1uv49obE5z-7JRJsTep_WduZi-X-HCnPvPXfwV41Cza4WjekIPl-G3_EtcWsKs&usqp=CAU"
        },
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
      "Viernes": [
        {
          "nombre": "correr ",
          "descripcion": "20 minutos a ritmo moderado.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
        {
          "nombre": "adominales",
          "descripcion": "30 repeticiones 5 veces",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHyDIAJrI_fkjj2Wg6XXLIgp6lhUm_XwmOvg&s"

        },
        {
          "nombre": "Plancha",
          "descripcion": "Mantén 1 min, repite 4 veces.",
          "imagen": "https://cdn.prod.website-files.com/609aa41bb752e648eb4cb693/610385bb1ea3fa831ee371ba_pexels-photo-2294354.jpeg"
        },
        {
          "nombre": "saltos de cuerda ",
          "descripcion": "durar lo de 20 min.",
          "imagen": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3n18uYZ007OS7ehV7WQbH0GB_JaYlVv_XA&s"
        },
      ],
    },
    "Avanzado": {
      "Lunes": [
        {
          "nombre": "Flexiones",
          "descripcion": "50 repeticiones.",
        },
        {
          "nombre": "Curl de bíceps",
          "descripcion": "5 series de 5 repeticiones.",
        },
        {
          "nombre": "Press banca",
          "descripcion": "5 series de 5 repeticiones.",
        },
        {
          "nombre": "Dominadas lastradas",
          "descripcion": "4 series de 6 repeticiones.",
        },
        {
          'nombre': 'martillos combinado con martillos de 90 grados',
          'descripcion': '4 series de 10 repeticiones.',
        },
        {
          'nombre': 'flexiones con salto',
          'descripcion': 'al fallo 4 veces',
        },
      ],
      'Martes': [
        {
          'nombre': 'dominadas',
          'descripcion': '50 repeticiones',
        },
        {
          'nombre': 'remo con barra',
          'descripcion': '4 series de 8 a 10 repeticiones.',
        },
        {
          'nombre': 'remo landmine unilateral',
          'descripcion': '4 series de 8 repeticiones.',
        },
        {
          'nombre': 'antebrazo',
          'descripcion': '4 series de 30 repeticiones.',
        },
        {
          'nombre': 'curp abierto',
          'descripcion': '4 series de 10 repeticiones.',
        },
        {
          'nombre': 'flexiones con salto',
          'descripcion': 'al fallo 4 veces',
        },
      ],
      'Miércoles': [
        {
          'nombre': 'Peso muerto',
          'descripcion': '5 series de 5 repeticiones.',
          'imagen': 'https://fitcron.com/wp-content/uploads/2021/04/00851301-Barbell-Romanian-Deadlift_Hips_720.gif',
        },
        {
          'nombre': 'Press militar con barra',
          'descripcion': '5 series de 5 repeticiones.',
          'imagen': 'https://www.thingys.com.ar/gymapps/tutorial/hom4.gif',
        },
        {
          'nombre': 'Remo con barra T',
          'descripcion': '4 series de 6-8 repeticiones.',
          'imagen': 'https://doriangym.es/wp-content/uploads/2022/10/remo-con-barra-a-un-brazo-1.gif',
        },
      ],
      'Jueves': [
        {
          'nombre': 'flexiones',
          'descripcion': '50 repeticiones',
        },
        {
          'nombre': 'curp de bicep',
          'descripcion': '5 series de 5 repeticiones.',
        },
        {
          'nombre': 'Press banca',
          'descripcion': '5 series de 5 repeticiones.',
        },
        {
          'nombre': 'Dominadas lastradas',
          'descripcion': '4 series de 6 repeticiones.',
        },
        {
          'nombre': 'martillos combinado con martillos de 90 grados',
          'descripcion': '4 series de 10 repeticiones.',
        },
        {
          'nombre': 'flexiones con salto',
          'descripcion': 'al fallo 4 veces',
        },
      ],
      'Viernes': [
      {
        'nombre': 'dominadas',
        'descripcion': '50 repeticiones',
      },
      {
        'nombre': 'remo con barra',
        'descripcion': '4 series de 8 a 10 repeticiones.',
      },
      {
        'nombre': 'remo landmine unilateral',
        'descripcion': '4 series de 8 repeticiones.',
      },
      {
        'nombre': 'antebrazo',
        'descripcion': '4 series de 30 repeticiones.',
      },
      {
        'nombre': 'curp abierto',
        'descripcion': '4 series de 10 repeticiones.',
      },
      {
        'nombre': 'flexiones con salto',
        'descripcion': 'al fallo 4 veces',
      },
      ],
    }
  };

  @override
  Widget build(BuildContext context) {
    final routine = routines[level];
    if (routine == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Rutina $level')),
        body: const Center(child: Text('No se encontraron rutinas para este nivel.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Rutina $level')),
      body: ListView(
        children: routine.entries.map((dayEntry) {
          final day = dayEntry.key;
          final exercises = dayEntry.value;

          return ExpansionTile(
            title: Text(day),
            children: exercises.map((exercise) {
              return ListTile(
                leading: exercise['imagen'] != null
                    ? Image.network(
                  exercise['imagen']!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : null,
                title: Text(exercise['nombre']!),
                subtitle: Text(exercise['descripcion']!),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
