import KlangraumKit
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
5. [Beispiel anhand eines Anwendungsfalls](#Beispiel)
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

In diesem Kapitel soll die explorative Herangehensweise beschrieben werden. Hinsichtlich der Projektbeschreibung und den Grundlagen der auditiven Wahrnehmung, wurde das folgende Konzept überlegt:

* **Hörtest**, um den hörbaren Frequenzbereich des Benutzers zu erfassen
* **Extrahieren von Samples in Mono und Stereo**, um die Audio-Datei anschließend angemessen bearbeiten zu können
* **Padding, Windowing und Splitting**, als Vorbereitung für die FFT
* **Manipulation der Samples mithilfe der FFT**, um das Audio-Signal an den Kontext des Benuters anzupassen
* **Modifizierte Samples als Audio-Datei abspielen**, um das Ergebnis zu hören

Die einzelnen Schritte können so komplex werden, dass an einigen Algorithmen und Methoden zwar eine ausreichende, aber nicht hinreichende Implementierung stattgefunden hat. Die detailierte Auseinandersetzung mit Audio-Algorithmen ist so umfangreich, dass sie ein eigenes Projekt mit Inhalt füllt. Aus diesem Grund ist die Implementierung der Anwendung als modulares Framework in Swift zum Manipulieren und Abspielen von Audio-Dateien für iOS-Systeme zu verstehen. 

Im Folgenden werden die einzelnen Schritte detailiert erklärt, begründet, implementiert und mithilfe des interaktiven Playgrounds vorgeführt.

### Hörtest

Um das Audio-Signal in einen für den Benutzer hörbaren Frequenzbereich anzupassen, muss zunächst der hörbare Frequenzbereich des Benutzers erfasst werden. Hierfür soll ein Hörtest implementiert werden, welcher das für den Mensch hörbaren Frequenzspektrum von 0 bis 22000 Hz mit einem akustischen Signal durchläuft. Sobald der Benutzer das Signal perzipiert drückt er auf eine dafür vorhergesehene Fläche und hält solange gedrückt, bis das Signal nicht mehr zu hören ist. Auf diese Weise erfasst und speichert das System die untere und obere Grenze an hörbaren Frequenzen. Die folgende Abbildung zeigt den Hörtest wie er in der iOS-Anwendung zu sehen ist:

![blabla](hearingtest.png)

Der Hörtest wurde mithilfe von [AudioKit](http://audiokit.io) impementiert. AudioKit liefert eine umfangreiche Bibliothek für das Erzeugen und Verarbeiten von Audio auf Basis von Apples APIs. Glücklicherweise haben die Entwickler von AudioKit bereits ein Bridging Projekt von Objective-C auf Swift bereitgestellt, weshalb die Anbindung problemlos verlief.

Im Folgenden wird eine gekürzte Implementierung des *HearingTestViewController* vorgestellt. Dieser erzeugt ein *ToneWidget*, welcher im Verlauf von 60 Sekunden ein Signal von 0 bis 22000 Hz generiert. Ein Blick in *Constants* zeigt die Konfiguration des Hörtests.

    struct Constants {
        static let StopToneGeneratorNotification = "stopToneGeneratorNotification"
        
        static let maxFrequency = "maxFrequency"
        static let minFrequency = "minFrequency"
        
        static let amplitude: Float = 0.25
        static let numInstruments = 1
        static let frequencyScale: Float = 22000
    }

Theoretisch lässt sich die Anzahl der ToneWidgets mit *numInstruments* steuern, um einen dedizierten Hörtest für beide Ohren durchzuführen. Aus diesem Grund wurde ein Array von ToneWidget angelegt. Des Weiteren lässt sich die Amplitude über *amplitude* ansteuern. In der *viewDidLoad* Funktion werden ToneWidget und SoundGenerator angelegt. Die *start* Funktion lässt den Hörtest solange laufen, wie der Benutzer auf das ToneWidget drückt. Erst wenn kein Ton mehr zu hören ist, lässt der Benutezr los, wodurch die *stop* Funktion aufgerufen wird. Da die Gesten im ToneWidget implementiert sind, ruf das Widget über das Notification-Pattern die *onStartAndStop* Funktion aus. Diese speichert die übergebene min- und max Frequenz. Diese beiden Schranken geben den vom Benutzer hörbaren Frequenzbereich an.

    import UIKit

    class HearingTestViewController: UIViewController {
        
        private var nsTimer: NSTimer?
        
        var toneWidgets = [ToneWidget]()
        let soundGenerator = SoundGenerator()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            soundGenerator.setUp()
            
            for i in 0 ..< Constants.numInstruments {
                let toneWidget = ToneWidget(channelNumber: i, frame: CGRectZero)
                
                toneWidget.addTarget(self, action: "toneWidgetChangeHandler:", forControlEvents: UIControlEvents.ValueChanged)
                
                toneWidgets.append(toneWidget)
                view.addSubview(toneWidget)
            }
        }
        
        @IBAction func start(sender: UIBarButtonItem) {
            guard let toneWidget = toneWidgets.first where Constants.numInstruments == 1 else { return }
            
            soundGenerator.playNoteOn(toneWidget.getFrequencyAmplitudePair(), channelNumber: 0)
            
            nsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0 / Double(Constants.frequencyScale * 60), target: self, selector: Selector("increase"), userInfo: nil, repeats: true)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("stop"), name: Constants.StopToneGeneratorNotification, object: nil)
        }
        
        func stop() {
            if let timer = nsTimer { timer.invalidate() }
            
            soundGenerator.stop()
            navigationItem.rightBarButtonItem?.enabled = true
        }
        
        func increase() {
            toneWidgets.first?.currentValue += 1.0 / Float(Constants.frequencyScale / 10)
            toneWidgets.first?.dialChangeHander()
        }
        
        func onStartAndStop(minFrequency: Float, maxFrequency: Float) {
            NSUserDefaults.standardUserDefaults().setFloat(minFrequency, forKey: Constants.minFrequency)
            NSUserDefaults.standardUserDefaults().setFloat(maxFrequency, forKey: Constants.maxFrequency)
        }
    }

Eine Erweiterung wäre es, wenn der Hörtest für beide Ohren getrennt durchgeführt wird, weil sich die Wahrnehmung durchaus unterscheiden kann. Dadurch lässt sich das Signal noch stärker an die auditive Wahrnehmung des Benutzers anpassen. Technisch gesehen extrahiert man beim Parsen der Audiodatei die Samples entweder Mono oder Stereo. Liegen die Samples in Stereo vor, kann das Anpassen des Signals pro Ohr erfolgen.

Der Hörtest lässt sich noch weiter verfeinern, indem zusätzlich unterschiedliche Amplituden pro Frequenzbereich abgefragt werden. Auch hierbei bewirkt der weitere Parameter eine detaillierte Anpassung des Signals.

Im Rahmen des Prototypen wurde lediglich der Hörtest ohne Berücksichtung von Stereo implementiert. Des Weiteren wird zwar das Regulieren der Amplitude ermöglicht, allerdings nicht in Relation zur Frequenz erfasst. Für die Validierung des Konzeptes wird lediglich der vom Benutzer hörbare Frequenzbereich benötigt. Die Granularität hat keine Auswirkung auf das Vorgehen. Die oben gezeigte Implementierung liefert hierfür dennoch die notwendigen Schnittstellen.

### Extrahieren von Samples in Mono und Stereo

Das musst du machen.

### Padding, Windowing und Splitting

Hierfür müssen wir uns absprechen

### Manipulation der Samples mithilfe der FFT

Der Kern der Anwendung befasst sich mit der FFT. Die Implementierung muss in der Lage sein, eingehende Samples von einer zeitbasierten Darstellung in eine frequenzbasierte Darstellung zu überführen. In der frequenzbasierten Darstellung liegen die Daten als komplexe Zahlen vor. Die Anwendung muss ebenfalls in der Lage sein, aus den komplexen Zahlen reale Zahlen oder Polarkooridinaten zu extrahieren. Mithilfe dieser Operationen wird das Signal bearbeitet. Anschließed muss eine inverse FFT implementiert werden, welche die komplexen Zahlen in Samples überführt. Das Manipulieren des Signals sollte modular implementiert werden, sodass man nachträglich Algorithmen hinzufügen und zur Laufzeit austauschen kann.

Die API zum Umgang mit der FFT sollte die oben genannten Anforderungen erfüllen. Im Kontext von iOS bietet Apple selbst eine API zur digitalen Signalverarbeitung namens [vDSP](https://developer.apple.com/library/prerelease/ios/documentation/Accelerate/Reference/vDSPRef/index.html) an. vDSP nutzt das [Accelerate Framework](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/AccelerateFWRef/index.html#other), welches eine C-API zum Verarbeiten von Vektoren, Matrizen, digitalen Signalen, Bildern usw. anbietet. Einen leichtgewichtigen Wrapper um die *low-level* APIs gibt es nicht, vor allem nicht für Swift. Aus diesem Grund kommt eine weitere Herausforderung hinzu: die Nutzung von C-artigen, adress- und pointerbasierten Funktionen in einer modernen Programmiersprache, die aus der Intention heraus entwickelt wurde, seinen C-Balast abzuwerfen. Unabhängig davon, fällt die Wahl auf vDSP und dem Accelerate Framework, da beide APIs von Apple für iOS Systeme angeboten werden, um digitale Signalverarbeitung zu vermöglichen. Des weiteren scheint die Benutzung beider APIs eher mit Swift zu harmonieren, als eine C oder C++ API. Das wichtige Kriterium ist jedoch, dass beide APIs laut dem [vDSP Reference Guide](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/vDSPRef/index.html#//apple_ref/doc/uid/TP40009464) die oben genannten Anforderungen erfüllen.

#### FFT Datenstrukturen

Die Implementierung der FFT-Komponente beginnt mit den Datenstrukturen. Die Funktionen der vDSP API sind so aufgebaut, dass sie, neben primitiven Parametern wie Int und Double, UsafePointer und UnsafeMutablePointer entgegennehmen oder zurückgeben:

    import Accelerate

    func vDSP_zvmags(__A: UnsafePointer<DSPSplitComplex>, _ __IA: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length) {}
    func vDSP_mmul(__A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __M: vDSP_Length, _ __N: vDSP_Length, _ __P: vDSP_Length) {}

Die erste Funktion extrahiert die Magnitudes aus einer komplexen zahl. Die zweite Funktion multipliziert zwei Magnitude-Arrays. UsafePointer und UnsafeMutablePointer werden benutzt, um mit den Adressen der Variablen zu arbeiten (Pointer). Alle vDSP Funktionen sind c-artig implementiert. Sie nehmen die Adresse einer Variable entgegen, manipulieren den Wert und geben *keinen* Wert zurück (*side effect*). 

Um im Kontext einer modernen, multiparadigmen Programmiersprache, mit solch einer Art von Funktionen zu arbeiten, wird die Benutzung der vDSP API mithilfe von Datenstrukturen und Funktionen abstrahiert. Zunächst werden die Datenstrukturen vorgestellt. Im übernächten Kapitel (Operationen auf komplexen Zahlen) werden die Funktionen vorgestellt. 

    struct Complex<T> {
        var real: T
        var imag: T
    }

    struct SplitComplexVector<T> {
        var real: [T]
        var imag: [T]
        
        init(real: [T], imag: [T] ) {
            self.real = real
            self.imag = imag
        }
        
        init( count: Int, repeatedValue: Complex<T> ) {
            self.real = [T]( count: count, repeatedValue: repeatedValue.real )
            self.imag = [T]( count: count, repeatedValue: repeatedValue.imag )
        }
        
        subscript(i: Int) -> Complex<T> {
            return Complex<T>(real: real[i], imag: imag[i]);
        }
        
        var count: Int { return real.count }
    }

Als erstes wird die Struktur einer komplexen Zahl beschrieben, welche aus einer realen und einer imaginären Zahl besteht. Der Typ *T* kann wahlweise Double oder Float sein. Ein *SplitComplexVector* beschreibt eine Menge von komplexen Zahlen, wobei der reale und imaginäre Anteile getrennt betrachtet werden. Des Weiteren wird der Zugriff auf den SplitComplexVector mithilfe des Subscripts vereinfacht:
*/
let vector = SplitComplexVector<Float>(count: 10, repeatedValue: Complex<Float>(real: 0, imag: 0))

let first = vector[0] // subscript, element an der Stelle 0
/*:
#### Die FFT Klasse

Gemäß den oben genannten Anforderungen muss die FFT Implementierung eine Hin- und Rücktransformation ermöglichen:

    protocol Transformation {
        
        func forward() -> SplitComplexVector<Float>
        
        func inverse(x: SplitComplexVector<Float>) -> [Float]
    }

Das Protocol definiert die Transformationen von **real -> forward -> complex -> inverse -> real**. Der Eingabeparameter sind die Samples als Float Array. Die Forward-Funktion gibt einen SplitComplexVector vom Typ Float zurück, welcher als Eingabeparameter für die Inverse-Funktion verwendet wird, welche wiederum Samples als Float Array zurückgibt. Die komplexen Zahlen, zwischen Forward und Inverse, werden für Manipulationen am Signal verwendet, welches im übernächsten Kapitel (Strategien zum Manipulieren der Magnitudes) beschrieben wird.

Die vDSP API benötigt für die FFT ein FFT-Setup und einige Konstanten. Die notwendigen Parameter werden für die aufrufende Instanz über den Konstruktor abstrahiert. Der Konstruktor selbst benötigt lediglich die Samples als Float Array:

    class FFT {
        
        private let setup: FFTSetup
        private let length: Int
        private let samples: [Float]

        init(initWithSamples samples: [Float]) {
            self.samples = samples
            self.length = samples.count
            self.setup = vDSP_create_fftsetup(vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2))
        }
        
        func destroyFFTSetup() {
            vDSP_destroy_fftsetup(setup)
        }
    }

Die beiden Transformationsfunktionen werden implementiert, indem die Klasse FFT um das Transformation Protocol erweitert wird :

    extension FFT: Transformation {
        
        func forward() -> SplitComplexVector<Float> {
            var splitComplex = SplitComplexVector<Float>(count: length / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            samples.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
                let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
                vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
                vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(FFT_FORWARD))
            }
            
            return splitComplex
        }
        
        func inverse(x: SplitComplexVector<Float>) -> [Float] {
            var splitComplex = x
            var result = [Float](count: length, repeatedValue: 0)
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
                vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(kFFTDirection_Inverse))
                vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
            }
            
            vDSP_vsmul(result, 1, [0.5/Float(length)], &result, 1, vDSP_Length(length))
            
            return result
        }
    }

Die Forward-Funktion erzeugt sich zunächst einen *SplitComplexVector* mit der Größe Samples/2, weil die FFT aus N Samples ein N/2 großes Array erzeugt, da die Hälfte Redundant ist. Der SplitComplexVector wird mit komplexen Zahlen, 0+0i, aufgefüllt und anschließend als Pointer an den *DSPSplitComplex* übergeben, welcher von der vDSP API als Quelle der FFT Daten benötigt wird. Um die Werte aus den Samples in den DSPSplitComplex zu kopieren, wird die vDSP-Funktion *vDSP_ctoz()* verwendet. Da alle vDSP-Funktionen mit Pointern und Adressen arbeiten, muss mithilfe der *withUnsafeBufferPointer*-Funktion die Adresse der Samples ausgelesen und als *UnsafePointer* vom Typ *<DSPComplex>* der eigentlichen vDSP_ctoz-Funktion übergeben werden. Auf diese Weise wird die Adresse des aktuellen Samples als *xAsComplex* übergeben und dessen dereferentierter Wert in den Pointer von *dspSplitComplex* geschrieben. Die letzte Zeile der Closure führt die eigentliche FFT aus. vDSP sieht insgesamt 12 Funktionen für die Fourier Transformation vor, welche sich beispielsweise darin unterscheiden, ob eine 1D oder 2D Transformation durchgeführt werden soll. Des Weiteren wird unterschieden, ob das Ergebnis In-Place oder Out-of-Place und als Float oder Double zurückgegeben werden soll. Aufgrund der zuvor definierten Anforderungen an die FFT, wird die *vDSP_fft_zrip*-Funktion verwendet, welche eine In-Place Transformation mit einfacher Präzision (Float) durchgeführt. Als Parameter werden das in der Init erstellte FFT-Setup, die Adresse von *dspSplitComplex*, die Länge und die Richtung (Forward oder Inverse) übergeben. Die *vDSP_fft_zrip*-Funktion modifiziert die *dspSplitComplex* Variable mit dem Ergebnis der FFT (side effect). Da sowohl der reale als auch der imaginäre Anteil von DSPSplitComplex mit der Adresse von SplitComplexVector initialisiert wurde, gibt die Forward-Funktion nicht den Datentyp von vDSP (DSPSplitComplex), sondern das selbst geschrieben Hilfstruct (SplitComplexVector) zurück. Auf diese Weise ist die Implementierung der FFT-Klasse nicht abhängig von der vDSP API. Bei Bedarf kann die low-level API ausgewechselt werden, ohne das aufrufende Instanzen, die das Transformation-Protocol verwenden, geändert werden müssen. 

Im folgenden wird eine Forward-Transformation mithilfe des Transformation-Protocol am Beispiel eines Sinus artigen Signals durchgeführt. Zunächst das Erzeugen des Sinus-Signals: */
import Accelerate

private func sin(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvsinf(&results, x, [Int32(x.count)])
    
    return results
}

let count = 64
let frequency: Float = 4.0
let amplitude: Float = 3.0

let sineValues = (0..<count).map { Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
let samples: [Float] = sin(sineValues)

samples.map{ $0 }
/*:
Mithilfe der Map-Funktion wird eine Sinus-Funktion mit 64 Samples erzeugt und anschließend gezeichnet. Die Samples sollen nun als Basis für die FFT-Forward-Funktion verwendet werden. Das Ergebnis wird ebenfalls gezeichnet:
*/
private func magnitudes( var x: SplitComplexVector<Float> ) -> [Float] {
    var magnitudes = [Float]( count: x.count, repeatedValue: 0 )
    
    let dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    for i in 0..<x.count {
        magnitudes[i] = sqrt(dspSplitComplex.realp[i] * dspSplitComplex.realp[i] + dspSplitComplex.imagp[i] * dspSplitComplex.imagp[i])
    }
    
    return magnitudes
}

let fft = FFT(initWithSamples: samples)
let forward = fft.forward()

magnitudes(forward).map{ $0 }
/*:
Die Funktion *magnitudes(A) -> B* ist Hilfsfunktion, die erst im nächsten Unterkapitel besprochen werden. Sie wird benötigt, um die Magnitudes aus den komplexen Zahlen zu extrahieren, die anschließend gezeichnet wurden. Im Folgenden sollen die komplexen Zahlen mithilfe der Inverse-Funktion wieder in das Ausgangssignal zurückgerechnet und anschließend gezeichnet werden: */
let inverse = fft.inverse(forward)

inverse.map{ $0 }
/*:
#### Operationen auf komplexen Zahlen
Wie die Magnitudes-Funktion gezeigt hat, werden einige weitere Funktionen benötigt, welche auf den Daten der FFT operieren. Da die meisten dieser Funktionen intern die Funktionen der vDSP API verwenden, um beispielsweise aus komplexen Zahlen (DSPSplitComplex) Polarkorrdinaten zu extrahieren, wurden die Funktionen wiederum in Swift Funktionen gewrapped. Die Swift Funktionen haben meistens eine Signatur von *SplitComplexVector<A> -> Array<A>*, um nicht von der vDSP API abhängig zu sein. Auch hier kann die Bibliothek für die digitale Signalverarbeitung ausgetauscht werden, ohne das Änderungen bei der aufrufenden Instanz durchgeführt werden müssen.

Neben der Magnitudes-Funktion werden noch einge wichtige Funktionen vorgestellt: */
func normalizedMagnitudes(var x: SplitComplexVector<Float>) -> [Float] {
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    var magnitudes = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_zvmags(&dspSplitComplex, 1, &magnitudes, 1, vDSP_Length(x.count))
    
    var normalizedMagnitudes = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_vsmul(sqrt(magnitudes), 1, [2.0 / Float(x.count * 2)], &normalizedMagnitudes, 1, vDSP_Length(x.count))
    
    return normalizedMagnitudes
}

func abs(var x: SplitComplexVector<Float> ) -> [Float] {
    var result = [Float]( count: x.count, repeatedValue: 0 )
    
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    vDSP_zvabs( &dspSplitComplex, 1, &result, 1, vDSP_Length(x.count) )
    
    return result
}

func polarCoordinates(var x: SplitComplexVector<Float>) -> (mag: [Float], phase: [Float]) {
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    var magnitudes = [Float](count: x.count, repeatedValue: 0.0)
    var phase = [Float](count: x.count, repeatedValue: 0.0)
    
    vDSP_zvabs(&dspSplitComplex, 1, &magnitudes, 1, vDSP_Length(x.count))
    vDSP_zvphas(&dspSplitComplex, 1, &phase, 1, vDSP_Length(x.count))
    
    return (magnitudes, phase)
}

polarCoordinates(forward).phase.map{ $0 }

func maxHz(samples: [Float], rate: Int) -> Float {
    let length = samples.count / 2
    
    var max: Float = 0.0
    var maxIndex = vDSP_Length(0)
    vDSP_maxvi(samples, 1, &max, &maxIndex, vDSP_Length(length));
    
    return (Float(maxIndex) / Float(length)) * (Float(rate) / 2)
}

maxHz(samples, rate: count)
/*:
Die erste Funktion, *normalizedMagnitudes(A) -> B*, berechnet die Magnitudes einer komplexen Zahl A mithilfe der *vDSP_zvmagsD* Funktion, im Gegensatz zur bereits vorgestellten *magnitudes(A) -> B* Funktion, welche ohne die vDSP API auskommt. Des Weiteren werden die Magnitudes normalisiert, weil *vDSP_zvmags* die quadrierten Magnitudes des komplexen Vektors zurückgibt. Auch die Funktion *abs(A) -> B* macht letztlich das Gleiche wie *magnitudes* und *normalizedMagnitudes*, außer das Normalisieren. Eine neue Funktion ist *polarCoordinates(A) -> (B, B)*, welche die Polarkoordinaten als Tupel zurückgibt. Hierbei beschreiben Magnitudes den Abstand zu 0 und Phase den Winkel zur Koordinate. Zuletzt sei noch die Funktion *maxHz(A, B) -> C* erwähnt, welche die Frequenz der übergebenen Samples A unter Berücksichtigung der Samplingrate B mithilfe der *vDSP_maxvi*-Funktion berechnet. Die Funktion wird am Beispiel der Sinus-Funktion aufgerufen und gibt die Frequenz 4 zurück. Angesichts der Zeile *let frequency: Float = 4.0* stimmt das Ergebnis.

#### Strategien zum Manipulieren der Magnitudes

Bislang verfügt die FFT-Klasse lediglich um die Funktion der Hin- und Rücktransformation. Allerdings wird eine Implementierung benötigt, die eine Manipulation des Signales ermöglicht. Genauer gesagt müssen zwischen der Forward- und Inverse-Funktion die Magnitudes aus den komplexen Zahlen extrahiert, manipuliert und anschließend wieder als komplexe Zahlen zurückgegeben werden. Demnach hat die Funktion eine Signatur von *apply(A) -> A*, wobei A vom Typ Array(Float) oder Array(Double) sein sollte. 

Um mehrere Strategien für das Manipulieren von Daten zu ermöglichen und diese dynamisch zur Laufzeit hinzufügen zu können, wird ein *FilterStrategy*-Protocol mit der oben genannten Funktions-Signatur deklariert. Des Weiteren wird ein *Filterable*-Protocol definiert, welcher der FFT-Klasse ermöglicht, eine Array von Filter-Strategien zu setzen, um mehrere Strategien zu komponieren. Hierbei liegen alle Implementierungen von FilterStrategy als Strategy-Pattern vor. Auf die Weise kann beispielsweise erst eine Noise-Reduction erfolgen, bevore das Signal in einen bestimmten Frequenzbereich gemaped wird. 

    protocol FilterStrategy {
        
        func apply(x: [Float]) -> [Float]
    }

    protocol Filterable {
        
        var strategy: [FilterStrategy] { get set }
    }

    extension FFT: Filterable {
        
        var strategy: [FilterStrategy]
        
        convenience init(initWithSamples samples: [Float], andStrategy strategy: [FilterStrategy]) {
            self.init(initWithSamples: samples)
            self.strategy = strategy
        }
    }

Über einen weiteren Konstruktur wird ein Array von FilterStrategy übergeben. Als nächstes folgt die Implementierung der Funktion, welche die Magnitudes auf den komplexen Zahlen extrahiert und die *apply-Funktion* aller Filter-Strategies komponiert. Die Funktion setzt bei *complex* zwischen *forward -> complex* und *complex -> inverse* an und hat demnach eine Signatur von *A -> A* wobei A ein SplitComplexVector vom Typ Float ist.

    extension FFT {
        
        func applyStrategy(x: SplitComplexVector<Float>) -> SplitComplexVector<Float> {
            var splitComplex = x
            let result = [Float](count: length, repeatedValue: 0)
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
                vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
            }
            
            let applied = strategy.reduce(result) { $1.apply($0) }
            
            applied.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
                let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
                vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
            }
            
            return splitComplex
        }
    }

Vor und nach dem Anwenden der Strategien müssen die komplexen Zahlen, ähnlich wie bei *forward()* und *inverse()*, zunächst mithilfe der *withUnsafeBufferPointer()*-Funktion ausgepackt, aufgebreitet und als *DSPSplitComplex* zurückgegeben werden. Das eigentliche Anwendungen erfolgt mithilfe der funktionalen Reduce-Funktion. Diese wird mit den Werten des Übergabeparameters *x*, den Magnitudes der komplexen Zahlen aus der Forward-Funktion, intialisiert. Basierend auf diesem Startwert wird für jede Strategy $1 die *apply()* Funktion mit dem vorherigen Ergebnis $0 aufgerufen. Auf diese Weise werden alle Strategien komponiert und das Ergebnis mithilfe der *withUnsafeBufferPointer()*-Funktion als *SplitComplexVector* vom Typ Float zurückgegeben. 

Im Folgenden wird ein Workflow für das Manipulieren des oben definierten Sinus-Signals beschrieben. Hierfür wird eine Double-, Tripple und eine No-Strategy als Implementierung von FilterStrategy verwendet, um die Komposition der Strategien zu testen. 

    class NoStrategy: FilterStrategy {
        func apply(x: [Float]) -> [Float] {
            return x
        }
    }

    class DoubleStrategy: FilterStrategy {
        func apply(x: [Float]) -> [Float] {
            return x.map { $0 * 2 }
        }
    }

    class TrippleStrategy: FilterStrategy {
        func apply(x: [Float]) -> [Float] {
            return x.map { $0 * 3 }
        }
    }

*/
let fftWithStr = FFT(initWithSamples: samples, andStrategy: [DoubleStrategy(), NoStrategy(), TrippleStrategy()])
let f = fftWithStr.forward()
let applied = fftWithStr.applyStrategy(f)
let i = fftWithStr.inverse(applied)

i.map{$0}
max(samples)
max(i)
/*: Auch wenn die oben gezeichnete modifizierte Sinus-Funktion sich opisch nicht von der am Anfang gezeigten Sinus-Funktion unterscheidet, ist das Entscheidende der *max()*-Funktion zu entnehmen. Während der höchste Wert der originalen Sinus-Samples 1 beträgt, ist es bei dem modifizierten Signal eine 6, weil 1 (original) * 2 (DoubleStrategy) * 3 (TrippleStrategy) = 6 ergibt. Um den Aufruf von *forward -> apply -> inverse* etwas angenehmer zu gestalten, wurde ein überladener Operator *-->* eingeführt, welcher das Ergebnis von *Left* als Übergabeparameter von *Right* weiterleitet. Demnach können die folgenden zwei Signaturen aufreten

* --><A, B>(A, A -> B) -> B und 
* --><A>(A, A -> A) -> A

auftreten, weil die Überführung entweder von Array<Float> zu Array<Float>, SplitComplexVector<Float> zu SplitComplexVector<Float> oder von SplitComplexVector<Float> zu Array<Float> erfolgt. Intern wird das Ergebnis von Links der Funktion von Rechts übergeben und dessen Ergebnis als nächstes Links zurückgegeben: */

let overload = FFT(initWithSamples: samples, andStrategy: [DoubleStrategy(), NoStrategy(), TrippleStrategy()])
let a = overload.forward --> overload.inverse
/*:

Die modulare Implementierung der FFT-Klasse und dem Strategy-Pattern erlaubt das Hinzufügen von Strategien, die von der FFT berücksichtigt werden. Im Rahmen des Prototypen wurden die Algorithmen zu den Mapping- und Noise-Reduction-Strategien naiv implementiert. Sie führen zwar zu einem Ergebnis, allerdings sind noch einige unsaubere Annahmen drin, die nicht zum erwarteten Ergebnis führen. Das intensive Auseinandersetzen mit angemessenen Algorithmen würde zu viel Zeit in Anspruch nehmen, da die theoretischen Hintergründe fundierter betrachtet werden müssen. Aus diesem Grund werden lediglich die naiven Algorithmen von Noise-Reduction und Mapping-Strategien besprochen. Zu einem späteren Zeitpunkt können die Implementierungen erweitert und ausgetauscht werden.

#### Noise-Reduction- und Mapping-Strategien

### Modifizierte Samples als Audio-Datei abspielen, ein ganzheitliches Beispiel

## Beispiel anhand eines Anwendungsfalls

Hierfür müssen wir uns absprechen

*/

/*:
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
