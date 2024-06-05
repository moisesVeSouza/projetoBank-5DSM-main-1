import 'package:bank/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    BankApp(),
  );
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(
          0,
          56,
          168,
          1.0,
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://asbraf.com/wp-content/uploads/2020/04/bb3.png'),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListaContatos(),
                  ),
                );
              },
              child: Container(
                height: 140,
                width: 120,
                padding: EdgeInsets.all(8.0),
                color: Color.fromRGBO(0, 56, 168, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      'Contatos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaContatos extends StatefulWidget {
  ListaContatos({super.key});

  @override
  _ContatosListaState createState() => _ContatosListaState();
}

class _ContatosListaState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(
          0,
          56,
          168,
          1.0,
        ),
        title: Text(
          'Contatos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        initialData: const [],
        future: Future.delayed(Duration(seconds: 1)).then((value) => findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;

            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Text("Loading"),
                  ],
                ),
              );
              break;

            case ConnectionState.active:
              break;

            case ConnectionState.done:
              final List<Contato> contatos = snapshot.data as List<Contato>;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Contato contato = contatos[index];
                  return _ContatoItem(contato);
                },
                itemCount: contatos.length,
              );
              break;
          }
          return Text("Unkown error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 56, 168, 1.0),
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => FormularioContatos(),
                ),
              )
              .then(
                (value) => setState(() {}),
              );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );
  }
}

class FormularioContatos extends StatefulWidget {
  FormularioContatos({super.key});

  @override
  _FormularioContatosState createState() => _FormularioContatosState();
}

class _FormularioContatosState extends State<FormularioContatos> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorNumeroConta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(
          0,
          56,
          168,
          1.0,
        ),
        title: Text(
          'Novo Contato',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorNome,
              decoration: InputDecoration(
                labelText: 'Nome Completo',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            TextField(
              controller: _controladorNumeroConta,
              decoration: InputDecoration(
                labelText: 'Número da Conta',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(0, 56, 168, 1.0),
                    ),
                  ),
                  onPressed: () {
                    final String nome = _controladorNome.text;
                    final int? numeroConta =
                        int.tryParse(_controladorNumeroConta.text);
                    final Contato novoContato = Contato(0, nome, numeroConta);
                    save(novoContato)
                        .then((id) => Navigator.pop(context, novoContato));
                  },
                  child: Text(
                    'Salvar',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contato {
  final int id;
  final String nome;
  final int? numeroConta;

  Contato(this.id, this.nome, this.numeroConta);

  @override
  String toString() {
    return 'Contato{id: $id, nome: $nome, numeroConta: $numeroConta}';
  }
}

class _ContatoItem extends StatelessWidget {
  final Contato contato;
  _ContatoItem(this.contato);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contato.nome,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contato.numeroConta.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
