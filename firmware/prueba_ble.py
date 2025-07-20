from machine import Pin
import bluetooth
from time import sleep
import gc
from ble_advertising import advertising_payload
from micropython import const
from ubluetooth import BLE, UUID, FLAG_READ, FLAG_WRITE

# Pines del ESP32-C3 para los 4 relés
relay_pins = [Pin(2, Pin.OUT), Pin(3, Pin.OUT), Pin(4, Pin.OUT), Pin(5, Pin.OUT)]

# UUIDs personalizados (servicio y característica)
SERVICE_UUID = UUID("19B10000-E8F2-537E-4F6C-D104768A1214")
CHAR_UUID = UUID("19B10001-E8F2-537E-4F6C-D104768A1214")

# Constantes de eventos BLE
_IRQ_CENTRAL_CONNECT = const(1)
_IRQ_CENTRAL_DISCONNECT = const(2)
_IRQ_GATTS_WRITE = const(3)


class BLEPeripheral:
    def __init__(self, ble, name="RelayCtrl"):
        gc.collect()  # Liberar memoria antes de usar BLE
        self._ble = ble
        self._ble.active(True)
        self._ble.irq(self._irq)

        self._connections = set()
        self._handle = None

        # Definir el servicio y la característica
        self._service = (
            SERVICE_UUID,
            (
                (CHAR_UUID, FLAG_READ | FLAG_WRITE),
            )
        )

        ((self._handle,),) = self._ble.gatts_register_services((self._service,))
        self._advertise(name)

    def _irq(self, event, data):
        if event == _IRQ_CENTRAL_CONNECT:
            conn_handle, addr_type, addr = data
            print("🔗 Conectado a:", bytes(addr))
            self._connections.add(conn_handle)

        elif event == _IRQ_CENTRAL_DISCONNECT:
            conn_handle, addr_type, addr = data
            print("❌ Desconectado:", bytes(addr))
            self._connections.discard(conn_handle)
            self._advertise()  # Reanudar publicidad

        elif event == _IRQ_GATTS_WRITE:
            conn_handle, attr_handle = data
            if attr_handle == self._handle:
                value = self._ble.gatts_read(self._handle)
                print("📩 Comando recibido:", value)
                self._process_command(value)

    def _advertise(self, name="RelayCtrl", interval_us=500000):
        payload = advertising_payload(name=name)  # SOLO el nombre, sin UUIDs
        self._ble.gap_advertise(interval_us, adv_data=payload)
        print("📢 Publicidad BLE activa como:", name)

    def _process_command(self, value):
        if not value:
            return
        cmd = int(value[0])

        if cmd == 0:
            print("Relay 1 OFF")
            relay_pins[0].value(0)
        elif cmd == 1:
            print("Relay 1 ON")
            relay_pins[0].value(1)
        elif cmd == 2:
            print("Relay 2 OFF")
            relay_pins[1].value(0)
        elif cmd == 3:
            print("Relay 2 ON")
            relay_pins[1].value(1)
        elif cmd == 4:
            print("Relay 3 OFF")
            relay_pins[2].value(0)
        elif cmd == 5:
            print("Relay 3 ON")
            relay_pins[2].value(1)
        elif cmd == 6:
            print("Relay 4 OFF")
            relay_pins[3].value(0)
        elif cmd == 7:
            print("Relay 4 ON")
            relay_pins[3].value(1)


# Inicio del programa
ble = bluetooth.BLE()
periferico = BLEPeripheral(ble)

while True:
    sleep(1)  # Mantener el script corriendo
