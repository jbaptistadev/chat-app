# Chat App

Esta es una aplicación de chat desarrollada con Flutter, un framework para construir aplicaciones nativas multiplataforma. La aplicación está diseñada para funcionar en múltiples plataformas, incluyendo Android, iOS, Linux y Windows.

## Características

- **Autenticación**: La aplicación incluye un servicio de autenticación (`AuthService`) para manejar el inicio de sesión y el registro de usuarios.
- **Conexión en Tiempo Real**: Utiliza `SocketService` para manejar la comunicación en tiempo real entre los usuarios.
- **Gestión de Chats**: `ChatService` se encarga de la lógica relacionada con los mensajes y las conversaciones.
- **Interfaz de Usuario**: La interfaz está construida con widgets de Flutter y sigue las guías de diseño de Material Design.

## Estructura del Proyecto

- **`lib/main.dart`**: Punto de entrada de la aplicación. Configura los proveedores de servicios y define las rutas de la aplicación.
- **`lib/screens`**: Contiene las diferentes pantallas de la aplicación, como la pantalla de registro (`register.dart`) y la pantalla de chat (`chat.dart`).
- **`lib/services`**: Contiene los servicios que manejan la lógica de la aplicación, como `AuthService`, `SocketService` y `ChatService`.
- **`assets`**: Contiene recursos estáticos como imágenes y archivos SVG.
- **`android`**: Configuraciones y código específico para la plataforma Android.
- **`ios`**: Configuraciones y código específico para la plataforma iOS.
- **`pubspec.yaml`**: Archivo de configuración de Flutter que define las dependencias del proyecto y otros ajustes.

## Cómo Funciona

1. **Inicio de la Aplicación**: La aplicación se inicia en `main.dart`, donde se configura `MyApp` como el widget principal.
2. **Proveedores de Servicios**: `MyApp` utiliza `MultiProvider` para inyectar `AuthService`, `SocketService` y `ChatService` en el árbol de widgets.
3. **Rutas de la Aplicación**: `MaterialApp` define las rutas de la aplicación, con `initialRoute` configurada en `'loading'` y las rutas definidas en `appRoutes`.
4. **Pantallas**: Las diferentes pantallas de la aplicación se encuentran en `lib/screens` y se navega entre ellas utilizando las rutas definidas.

## Instalación

1. Clona el repositorio:
   ```sh
   git clone https://github.com/tu-usuario/chat-app.git
   ```
2. Navega al directorio del proyecto:
   ```sh
   cd chat-app
   ```
3. Instala las dependencias:
   ```sh
   flutter pub get
   ```
4. Ejecuta la aplicación:
   ```sh
   flutter run
   ```
