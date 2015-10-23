/*: 

# Guided Projekt Typ B - Evaluierung von Methoden eines Klangmanagements zur Anpassung von Klangräumen an die Wahrnehmung

Interaktive Playground Dokumentation

ausgearbeitet von Alexander Dobrynin und Pascal Schönthier

im Studiengang Informatik Master - Software Engineering

betreut durch Prof. Dr. Lutz Köhler

## Inhaltsverzeichnis

1. [Einleitung](#Einleitung)
2. [Grundlagen](#Grundlagen)
3. [Theoretische Überlegungen, Konzeption und Umsetzung](#Theoretische-Überlegungen,-Konzeption-und-Umsetzung)
4. [Abschluss](#Abschluss)

## Kurzfassung

*kelines abstract hier*

* fast fourier transformation (fft)
* app entwicklung

## Einleitung

Das Projekt wurde aus eigenem Interesse vorgeschlagen und dahingehend formuliert, dass es sowohl einen wissenschaftlichen Anspruch hat, als auch eine explorative Herangehensweise beinhaltet. Grundlagen und Methoden wurden fundiert erhoben, gegeneinander abgewogen und qualitativ bewertet. Der Prozess und die Implementierung wurden wiederum agil und auf Basis des aktuellen Wissensstandes geprägt. Insgeasmt war das Vorgehen ergebnisorientiert, weshalb das vorliegende Dokument als interaktives Playground geschrieben ist. Aus diesem Grund steht die Implementierung im Vordergrund, die Prosa dient der Beschreibung und Argumentation. Zudem kann sie als roter Faden verstanden werden.

Im Folgenden soll die Arbeit mit einer kurzen Motivation eingeleitet werden. Danach folgt die Beschreibung des Ziels und dem Vorgehen, um das Ziel zu erreichen. Damit eine konkrete Anwendung entwickelt und getestet werden kann, wird ein Kontext definiert, welcher den Rahmen des Anwendungsfalls beschreibt und eingrenzt. Anschließend wird die Organisation des Dokumentes als interaktiven Playgrounds erläutert.

### Motivation

Jeder Mensch verliert im Laufe seines Lebens die Fähigkeit bestimmte Frequenzbereiche zu perzipieren. Die notwendige Hardware und Software, um Manipulationen an Audio-Dateien durchzuführen, tragen viele Menschen in Form vom Smartphones mit sich. Deshalb liegt es Nahe, ausgewählte Audio-Dateien vor dem Kosumieren an die Wahrnehmung des Menschen individuell anzupassen.

### Ziel und Vorgehen

Das primäre Ziel ist es, Möglichkeiten zum Verbessern bzw. Ausbessern des Frequenzverlustes anhand bestehender Audio-Aufnahmen zu evaluieren. Hierfür werden Ansätze in Form von Konzepten und Algorithmen recherchiert, gegeneinander abgewogen und in einer iOS-Anwendung implementiert. Dessen Wirksamkeit, Realisierbarkeit und Performanz im gegebenen Kontext steht hierbei im Vordergrund. Performanz deshalb, weil eine Verarbeitung in Echtzeit angestrebt wird.

Das sekundäre Ziel befasst sich mit Begriffsdefinitionen bezüglich dem Klangmanagment, des Klangraumes und der Klangwahrnehmung. Hierbei soll an die Verwandten Begriffe des Farbmangement, Farbraum und Farbwahrnehmung angelehnt werden.

### Kontext

Um die Algorithmen und Konzepte angemessen zu testen, soll ein Nutzungskontext der Anwendung definiert werden. Gleichzeitig dient der Nutzungskontext als Orientierungshilfe bei Entscheidungen und als Rahmen für die Projektgrenzen.

Der Kontext umfasst ein iPhone mit iOS 8 oder höher. Als Audio-Datei dienen Podcasts, die zum größten Teil aus menschlichen Stimmen bestehen. Allerdings wird auch Musik in den verschiedensten Formaten eingespielt, weshalb dieser Frequenzbereich ebenfalls berücksichtigt werden soll.

Bibliotheken und Schnittstellen sind nicht vorgeschrieben. Da die Anwendung in Swift entwickelt werden soll, sollten die verwendeten APIs möglichst selbst in Swift implementiert sein. Alternativ kann ein Objective-C oder sogar C-Bridging für *low-level* Verarbeitung eingesetzt werden.

### Organisation des Dokumentes

Das vorliegende Dokument ist als interaktives Playground organisiert. Während [Kapitel 1](#Einleitung) und [2](#Grundlagen) noch vollständig aus Text bestehen, ist [Kapitel 3](#Theoretische-Überlegungen,-Konzeption-und-Umsetzung) in einem Wechsel zwischen Text und Quellcode organisiert. Der Quellcode wird dynamisch kompiliert, weshalb der Leser Änderungen am Quellcode vornehmen kann, welche anschließend neu kompiliert und ggf. angezeigt werden. Das [letzte Kapitel](#Abschluss) ist ebenfalls klassisch, um das Fazit und die persönliche Einschätzung möglichst präzise, schlüssig und vieldimensional zu Gestalten.

## Grundlagen

### Begriffsdefinitionen

* Klangmanagement, Klangraum und Klangwahrnehmung
* Signal, Sample, Samplerate, Bin, Magnitude vs Amplitude, Mapping und Strategien

### Auditive Wahrnehmung

### Digitale Signalverarbeitung?

## Theoretische Überlegungen, Konzeption und Umsetzung

In diesem Kapitel soll die explorative Herangehensweise geschrieben werden. Hinsichtlich der Projektbeschreibung und den Grundlagen der auditiven Wahrnehmung, wurde das folgende Konzept überlegt.

* **Hörtest**, um den hörbaren Frequenzbereich des Benutzers zu erfassen
* **Extrahieren von Samples in Mono und Stereo**, um die Audio-Datei anschließend angemessen bearbeiten zu können
* **Padding, Windowing und Splitting**, als Vorbereitung für die FFT
* **Manipulation der Samples mithilfe der FFT**, um das Audio-Signal an den Kontext des Benuters anzupassen
* **Modifizierte Samples als Audio-Datei abspielen**, um das Ergebnis zu hören

Die einzelnen Schritte können so komplex werden, dass an einigen Algorithmen und Methoden zwar eine ausreichende, aber nicht hinreichende Implementierung stattgefunden hat. Die detailierte Auseinandersetzung mit Audio-Algorithmen ist so umfangreich, dass sie ein eigenes Projekt mit Inhalt füllt. Aus diesem Grund ist die Implementierung der Anwendung als modulares Framework in Swift zum Manipulieren und Abspielen von Audio-Dateien für iOS-Systeme zu verstehen. 

Im Folgenden werden die einzelnen Schritte detailiert erklärt, begründet, implementiert und mithilfe des interaktiven Playgrounds vorgeführt.

### Hörtest




## Abschluss

### Zusammenfassung und Fazit
### Persönliche Einschätzung und kritische Reflexion
### Ausblick

*/




/*import UIKit
import XCPlayground
import KlangraumKit
import AVFoundation

private func plot<T>(values: [T], title: String) {
    values.map{ XCPCaptureValue(title.isEmpty ? "foo" : title, value: $0) }
}

let audioFile = AudioFile()

if let data = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingString("/alex.m4a")) {

    let samplingRate = 44100
    let n = 1024
    let length = n / 2
    
    let max = 13000
    let min = 0
    
    let maxIndex = (length * Int(max)) / (samplingRate / 2 )
    let minIndex = (length * Int(min)) / (samplingRate / 2 )
    
    let padded = addZeroPadding(data, whileModulo: n)
    let window: [Float] = hamming(padded.count)
    let windowedData = window * padded
    let prepared = prepare(windowedData, steppingBy: n)
    
    let result = prepared.flatMap { samples -> [Float] in
        let f = FFT(initWithSamples: samples, andStrategy: [NoiseReductionStrategy()])
        return f.forward() --> f.applyStrategy --> f.inverse
    }
    
    audioFile.safeSamples(result, ToPath: NSBundle.mainBundle().bundlePath.stringByAppendingString("/blaalex.m4a"))
}*/
