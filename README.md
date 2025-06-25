# HeraGuard

App móvil que te ayuda a:
- Recordar tus citas médicas con alertas.
- Controlar tus medicamentos y horarios.

Todo en una interfaz sencilla diseñada para adultos mayores.

## 📋 Requisitos
- Flutter SDK instalado.
- Android Studio, VS Code o cualquier IDE compatible con Flutter.
- Emulador o dispositivo físico para ejecutar la aplicación.

## 🛠️ Instalación
1. Clona el repositorio:
```
git clone https://github.com/RolandoGuZz/Flutter_HeraGuard.git
```
2. Instala las dependencias:
```
flutter pub get
```
3. Ejecuta el proyecto:
```
flutter run
```

## 🏠 **Uso Básico**

### **Iniciar Sesión**
1. Ingresa tu correo y contraseña.
2. Presiona **"Iniciar Sesión"**.

### **Agendar una Cita**
1. Ve a **"Citas Médicas"** > Toca **"+1"**.
2. Completa el formulario de la cita.
3. Presiona **"Guardar Cita"**.

### **Registrar un Medicamento**
1. Ve a **"Medicamentos"** > Toca **"+1"**.
2. Ingresa los datos necesarios en el formulario.
3. Presiona **"Guardar Medicamento"**

## 🚀 Funcionalidades Implementadas
- CRUD completo para la gestión de citas médicas y medicamentos.
- Alertas para recordar citas y horarios de medicación.
- Navegación sencilla entre pantallas.

## 📱 Tecnologías Utilizadas
| Componente       | Tecnología           |
|------------------|---------------------|
| Frontend         | Flutter (Dart)      |
| Autenticación    | Firebase Auth       |
| Base de datos    | Cloud Firestore     |
| Notificaciones   | flutter_local_notifications |