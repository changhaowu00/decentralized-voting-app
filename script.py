import subprocess

def generate_rsa_key():
    command = "openssl genrsa -out private.pem 4096"
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        print("Pares de clave de longitud 4096 generado.")
    else:
        print(f"Error generating RSA key: {result.stderr}")

    extract_public_key()


def sign_message(message):
    private_key_file = "private.pem"
    message = "PP"
    command = f'echo -n "{message}" | openssl dgst -sha256 -sign {private_key_file} | xxd -p | tr -d \\n'
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        print("Message signed successfully. Signature in hex format:")
        print(result.stdout)
    else:
        print(f"Error signing message: {result.stderr}")

def extract_public_key():
    private_key_file = "private.pem"
    public_key_file = "public.pem"

    command = f"openssl rsa -in {private_key_file} -outform pem -pubout -out {public_key_file}"
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        print(f"Clave extraido y guardado a {public_key_file} y private.pem")
    else:
        print(f"Error extracción clave pública: {result.stderr}")

def parse_asn1_structure():
    public_key_file = "public.pem"
    
    command = f"openssl asn1parse -inform PEM -i -in {public_key_file} -strparse 19"
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    
    if result.returncode == 0:
        print(result.stdout)
    else:
        print(f"Error: {result.stderr}")


if __name__ == "__main__":
    while True:
        t = input("Introduce acción a realizar: \t\n   1 - Generar pares de claves \t\n   2 - Firmar mensaje \t\n   3 - Ver Propiedad clave Publica \t\n   4 - Salir \n" )
        if t == "1":
            generate_rsa_key()
        elif t == "3":
            parse_asn1_structure()
        elif t == "4":
            exit()
        elif t == "2": 
            mensaje_a_firmar = input("Introduce Mensaje a firmar :")
            sign_message(mensaje_a_firmar)
        print("\n")

