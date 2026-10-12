# 8086 Assembly String Manager

A low-level string manipulation utility written in x86/8086 Assembly language. This project demonstrates direct memory access, array traversal, and character manipulation using DOS interrupts and processor registers.

## 🚀 Key Features

*   **Interactive Menu:** Provides a console-based interface to interact with the stored string.
*   **Search Functionality:** Locates the first occurrence or all exact index positions of a specific character within the string.
*   **Character Replacement:** Allows the user to search for a specific letter and replace all its occurrences with a new one in real-time.
*   **String Clearing & Overwriting:** Safely clears the memory buffer to allow the entry of new strings without residual garbage data.
*   **Strict Input Validation:** Enforces ASCII range checking to ensure only alphabetical characters (A-Z, a-z) are processed during search and replace operations.

## 🧠 Technical Highlights & Memory Management

This project focuses on efficient array manipulation and state preservation at the hardware level:

*   **Indexed Addressing:** Utilizes the Source Index (`SI`) register to iterate through the 50-byte string buffer stored in the `.DATA` segment, simulating high-level array traversal.
*   **State Preservation:** Employs temporary variables (`tempDX`, `tempFflag`) to preserve critical register states during DOS `INT 21h` interrupts, preventing data corruption when the system takes control to print characters.
*   **Hexadecimal/ASCII Conversion:** Uses the `AAM` (ASCII Adjust for Multiply) instruction to dynamically convert binary loop counters (index positions) into printable ASCII digits for terminal output.

## 🛠️ Requirements & Usage

To assemble and run this code, you will need a 16-bit MS-DOS environment or emulator (like DOSBox) and an assembler toolchain (TASM/MASM).

### Compilation
1.  Assemble the code: `TASM StringManager.asm`
2.  Link the object file: `TLINK StringManager.obj`
3.  Run the executable: `StringManager.exe`

### Usage Instructions
1. Upon execution, type a string (up to 50 characters) and press Enter.
2. Select an option from the main menu (1-6).
3. Follow the on-screen prompts to search, find positions, modify characters, or input a new string.
