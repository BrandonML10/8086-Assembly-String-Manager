.MODEL SMALL
.STACK
.DATA
    cadena      db 50 dup(" "), "$"
    msgMenu     db 10,13, "Menu:",10,13, "1. Buscar letra en especifico",10,13, "2. Buscar todas las posiciones",10,13, "3. Borrar Dupla",10,13, "4. Ingresar nueva dupla",10,13, "5. Modificar caracter",10,13, "6. Salir",10,13, "Ingrese opcion: $"
    msgIngresa  db 10,13, "Ingrese una dupla: $"
    msgBuscar   db 10,13, "Ingrese caracter a buscar: $"
    msgmodificar   db 10,13, "Ingrese caracter a modificar: $"
    msgPorcual     db 10,13, "Ingrese por que letra a remplazar: $"
    msgEncontrado db 10,13, "El caracter esta en la dupla.$"
    msgNoEncontrado db 10,13, "El caracter no esta en la dupla.$"
    msgPosicion db 10,13, "Posicion: $"
    msgBorrada  db 10,13, "Dupla borrada.$"
    nuevaLinea  db 10,13, "$" ;SALTO DE LINEA
    msgErrorBusqueda db 10,13, "Error: Solo se permite buscar letras del abecedario.$"
    tempDX      dw ?      ; Variable temporal para guardar DX
    tempFflag   db ?
    auxLetraBuscar db ?
    auxLetraModificada db ?

.CODE
START:

    MOV AX, @DATA
    MOV DS, AX

    ; ===== Ingresar dupla inicial =====
    MOV AH, 09h
    LEA DX, msgIngresa
    INT 21h

    MOV AH, 3Fh
    MOV BX, 0
    MOV CX, 50
    MOV DX, OFFSET cadena
    INT 21h

    MOV SI, 0
INGRESAR_LOOP:
    CMP cadena[SI], 0Dh
    JE INGRESAR_REEMPLAZAR
    CMP cadena[SI], '$'
    JE INGRESAR_FIN
    INC SI
    JMP INGRESAR_LOOP
INGRESAR_REEMPLAZAR:
    MOV cadena[SI], '$'
INGRESAR_FIN:
    ; Acabe

MENU_PRINCIPAL:
    MOV AH, 09h
    LEA DX, msgMenu
    INT 21h

    ; Leer opción
    MOV AH, 01h
    INT 21h

    ; Evaluar opcion ingresada
    CMP AL, '1'
    JE BUSCAR_LETRA
    CMP AL, '2'
    JE BUSCAR_POSICIONES
    CMP AL, '3'
    JE BORRAR_DUPLA
    CMP AL, '4'
    JE NUEVA_DUPLA
    CMP AL, '5'
    JE MODIFICAR_LETRA
    CMP AL, '6'
    JE SALIR
    JMP MENU_PRINCIPAL

BUSCAR_LETRA:
    ; Pedir caracter a buscar
    MOV AH, 09h
    LEA DX, msgBuscar
    INT 21h

    MOV AH, 01h
    INT 21h
    ; Validar que el carácter sea letra (A-Z o a-z)
    CMP AL, 'A'
    JB ERROR_BUSCAR_LETRA
    CMP AL, 'Z'
    JBE VALID_BUSCAR_LETRA
    CMP AL, 'a'
    JB ERROR_BUSCAR_LETRA
    CMP AL, 'z'
    JBE VALID_BUSCAR_LETRA
ERROR_BUSCAR_LETRA:
    MOV AH, 09h
    LEA DX, msgErrorBusqueda
    INT 21h
    JMP MENU

VALID_BUSCAR_LETRA:
    MOV BL, AL
    MOV SI, 0
BUSCAR_LOOP:
    CMP cadena[SI], '$'
    JE NO_ENCONTRADO
    CMP cadena[SI], BL
    JE ENCONTRADO
    INC SI
    JMP BUSCAR_LOOP

ENCONTRADO:
    MOV AH, 09h
    LEA DX, msgEncontrado
    INT 21h
    JMP MENU

NO_ENCONTRADO:
    MOV AH, 09h
    LEA DX, msgNoEncontrado
    INT 21h
    JMP MENU

BUSCAR_POSICIONES:
    ; Pedir caracter a buscar
    MOV AH, 09h
    LEA DX, msgBuscar
    INT 21h

    MOV AH, 01h
    INT 21h
    ; Validar letra A-Z o a-z
    CMP AL, 'A'
    JB ERROR_BUSCAR_POS
    CMP AL, 'Z'
    JBE VALID_BUSCAR_POS
    CMP AL, 'a'
    JB ERROR_BUSCAR_POS
    CMP AL, 'z'
    JBE VALID_BUSCAR_POS
ERROR_BUSCAR_POS:
    MOV AH, 09h
    LEA DX, msgErrorBusqueda
    INT 21h
    JMP MENU

VALID_BUSCAR_POS:
    MOV BL, AL
    MOV SI, 0
    MOV CX, 1       ; Contador de posiciones 
    MOV DL, 0       ; Flag indica si encontre algo
    MOV tempFflag, 0

BUSCAR_POS_LOOP:
    CMP cadena[SI], '$'
    JE FIN_BUSCAR_POS
    CMP cadena[SI], BL
    JE MOSTRAR_POS
    INC SI
    INC CX
    JMP BUSCAR_POS_LOOP

MOSTRAR_POS:
    MOV tempDX, DX   ; Guardar DX en variable temporal
    MOV DL, 1
    MOV tempFflag, DL
    MOV AH, 09h
    LEA DX, msgPosicion
    INT 21h

    ; Convertir posición a dígitos ASCII
    MOV AX, CX
    AAM
    ADD AX, 3030h
    MOV DH, AL
    MOV DL, AH

    MOV AH, 02h
    INT 21h
    MOV DL, DH
    INT 21h

    MOV DX, tempDX   ; Restaurar DX
    INC SI
    INC CX
    JMP BUSCAR_POS_LOOP

FIN_BUSCAR_POS:
    CMP tempFflag, 0
    JNE MENU
    MOV AH, 09h
    LEA DX, msgNoEncontrado
    INT 21h
    JMP MENU

BORRAR_DUPLA:
    MOV SI, 0
    MOV CX, 50
BORRAR_LOOP:
    MOV cadena[SI], ' '
    INC SI
    LOOP BORRAR_LOOP
    MOV cadena[50], '$'
    MOV AH, 09h
    LEA DX, msgBorrada
    INT 21h
    JMP MENU

NUEVA_DUPLA:
    ; ===== Ingresar nueva dupla =====
    MOV AH, 09h
    LEA DX, msgIngresa
    INT 21h

    MOV AH, 3Fh
    MOV BX, 0
    MOV CX, 50
    MOV DX, OFFSET cadena
    INT 21h

    MOV SI, 0
NUEVA_LOOP:
    CMP cadena[SI], 0Dh
    JE NUEVA_REEMPLAZAR
    CMP cadena[SI], '$'
    JE NUEVA_FIN
    INC SI
    JMP NUEVA_LOOP
NUEVA_REEMPLAZAR:
    MOV cadena[SI], '$'
NUEVA_FIN:
    JMP MENU

MODIFICAR_LETRA:
    ; Pedir caracter a modificar
    MOV AH, 09h
    LEA DX, msgmodificar
    INT 21h

    MOV AH, 01h
    INT 21h
    ; Validar letra A-Z o a-z
    CMP AL, 'A'
    JB ERROR_BUSCAR_CARAC
    CMP AL, 'Z'
    JBE SEGUNDA_LETRA
    CMP AL, 'a'
    JB ERROR_BUSCAR_CARAC
    CMP AL, 'z'
    JBE SEGUNDA_LETRA
SEGUNDA_LETRA:
    ; Pedir caracter a modificar
    MOV auxLetraBuscar, AL
    MOV AH, 09h
    LEA DX, msgPorcual
    INT 21h

    MOV AH, 01h
    INT 21h
    
    ; Validar letra A-Z o a-z
    CMP AL, 'A'
    JB ERROR_BUSCAR_CARAC
    CMP AL, 'Z'
    JBE VALID_BUSCAR
    CMP AL, 'a'
    JB ERROR_BUSCAR_CARAC
    CMP AL, 'z'
    JBE VALID_BUSCAR

ERROR_BUSCAR_CARAC:
    MOV AH, 09h
    LEA DX, msgErrorBusqueda
    INT 21h
    JMP MENU

VALID_BUSCAR:
    MOV auxLetraModificada, AL
    MOV AL, auxLetraBuscar
    MOV BL, AL
    MOV SI, 0
    MOV CX, 1       ; Contador de posiciones 
    ;MOV DL, 0       ; Flag indica si encontre algo
    MOV tempFflag, 0 ; Flag indica si encontre algo

BUSCAR_POS_LOOPP:
    CMP cadena[SI], '$'
    JE IMPRIMIR
    CMP cadena[SI], BL
    JE CAMBIAR
    INC SI
    INC CX
    JMP BUSCAR_POS_LOOPP

CAMBIAR:
    MOV tempFflag, 1
    MOV tempDX, DX   ; Guardar DX en variable temporal
    MOV BL, auxLetraModificada
    MOV cadena[SI], BL

    MOV BL, auxLetraBuscar
    MOV DX, tempDX   ; Restaurar DX
    INC SI
    INC CX
    JMP BUSCAR_POS_LOOPP

IMPRIMIR:
    ; Imprimir nueva línea antes del resultado
    MOV AH, 09h
    LEA DX, nuevaLinea
    INT 21h

    ; Imprimir la dupla modificada
    MOV AH, 09h
    LEA DX, cadena
    INT 21h
    JMP FIN_BUSCAR

FIN_BUSCAR:
    CMP tempFflag, 0
    JNE MENU
    MOV AH, 09h
    LEA DX, msgNoEncontrado
    INT 21h
    JMP MENU


MENU:
    MOV AH, 09h
    LEA DX, nuevaLinea
    INT 21h
    JMP MENU_PRINCIPAL

SALIR:
    MOV AX, 4C00h
    INT 21h

END START
