import network, urequests, utime, machine

from machine import RTC, I2C, Pin

from ssd1306 import SSD1306_I2C



ssid = "botoneta" # No olvides colocar el nombre tu red WiFi

password = "zottoglez0716"  # No olvides colocar tu contrase±a

url = "https://worldtimeapi.org/api/timezone/America/Costa_Rica" # zonas en: http://worldtimeapi.org/timezones



print("Conectando ...")

oled = SSD1306_I2C(128, 64, I2C(0,scl=Pin(7), sda=Pin(8)))

oled.fill(0)

oled.text("Concectando", 25, 10)

oled.show()



rtc = RTC()



wifi = network.WLAN(network.STA_IF)

wifi.active(True)

wifi.connect(ssid, password)



while not wifi.isconnected():

    pass



print("IP:", wifi.ifconfig()[0], "\n")

oled.text("Conectado con IP: ", 0, 35)

oled.text(" " + str(wifi.ifconfig()[0]), 0, 45)

oled.show()



ultima_peticion = 0

intervalo_peticiones = 3600  # en segundos



while True:

    

    if not wifi.isconnected():

        print("fallo de conexi¾n a WiFi")

        #machine.reset()

    

    if (utime.time() - ultima_peticion) >= intervalo_peticiones:

        response = urequests.get(url)

    

        if response.status_code == 200:

            print("Respuesta:\n", response.text)

            

            datos_objeto = response.json()

            fecha_hora = str(datos_objeto["datetime"])

            a±o = int(fecha_hora[0:4])

            mes = int(fecha_hora[5:7])

            dÝa = int(fecha_hora[8:10])

            hora = int(fecha_hora[11:13])

            minutos = int(fecha_hora[14:16])

            segundos = int(fecha_hora[17:19])

            sub_segundos = int(round(int(fecha_hora[20:26]) / 10000))

        

            rtc.datetime((a±o, mes, dÝa, 0, hora, minutos, segundos, sub_segundos))

            ultima_peticion = utime.time()

            print("RTC actualizado\n")

   

        else:

            print("respuesta no vßlida: RTC no actualizado")

    

    fecha_pantalla = "{2:02d}/{1:02d}/{0:4d}".format(*rtc.datetime())

    hora_pantalla = "{4:02d}:{5:02d}:{6:02d}".format(*rtc.datetime())



    oled.fill(0)

    oled.hline(0, 0, 128, 1)

    oled.hline(0, 31, 128, 1)

    oled.text(hora_pantalla, 30, 8)

    oled.text(fecha_pantalla, 25, 17)

    oled.show()

    

    utime.sleep(0.1)