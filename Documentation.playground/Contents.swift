import KlangraumKit
/*:

# Guided Projekt Typ B - Evaluierung von Methoden eines Klangmanagements zur Anpassung von Klangräumen an die Wahrnehmung

Interaktive Playground Dokumentation

ausgearbeitet von Alexander Dobrynin und Pascal Schönthier

im Studiengang Informatik Master - Software Engineering

betreut durch Prof. Dr. Lutz Köhler

## Inhaltsverzeichnis

1. Einleitung
    * Motivation
    * Ziel und Vorgehen
    * Kontext
    * Organisation des Dokumentes
2. Grundlagen
    * Begriffsdefinitionen
    * Auditive Wahrnehmung
    * Digitale Signalverarbeitung
3. Theoretische Überlegungen, Konzeption und Umsetzung
    * Hörtest
    * Extrahieren von Samples aus einer Audio-Datei in Mono und Stereo
    * Padding, Windowing und Splitting
    * Manipulation der Samples mithilfe der FFT
        * FFT Datenstrukturen
        * Die FFT Klasse
        * Operationen auf komplexen Zahlen
        * Strategien zum Manipulieren der Magnitudes
        * Mapping-Strategien
        * Noise-Reduction-Strategien
    * Modifizierte Samples als Audio-Datei abspielen
5. Beispiel anhand eines Anwendungsfalls
4. Abschluss
    * Zusammenfassung
    * Persönliche Einschätzung und kritische Reflexion
    * Ausblick

## Kurzfassung

Die vorliegende Arbeit wurde im Rahmen des Guided-Project Typ B im Informatik Master, Schwerpunkt Software-Engineering, an der Fachhochschule Köln am Campus Gummersbach durchgeführt. Die Aufgabe des Guided-Project handelt von der Evaluierung von Methoden eines Klangmanagements zur Anpassung von Klangräumen an die Wahrnehmung.

Das Projekt befasst sich mit der Anpassung des Klangraumes an die individuelle Wahrnehmung. Hierfür wurde ein Kontext definiert, welcher die Rahmenbedingung für die Anpassung beschreibt. Daraufhin wurden Methoden und Techniken explorativ erkundet, um sich dem Thema zu nähern. Alle Ergebnisse befinden sich im vorliegenden Xcode Projekt sowohl in Form einer iOS-App, als auch im interaktiven Playground.

Das Evaluieren von Methoden bezieht sich auf die Auswahl von Algorithmen, welche die Anpassung von Klangräumen vornehmen. Die Algorithmen an sich wurden nicht all zu intensiv evaluiert, weil das Team schnell hörbare Ergebnisse erzielen wollte und sich deshalb zunächst dem FFT-Stack gewidmet hat. Es wurde vielmehr ein Framework für das Klangmanagement, dem Anpassen von Klangräumen an die individuelle Wahrnehmung des Menschen in Form einer iOS-App entwickelt. Dabei wurde das Framework so modular entwickelt, dass die Methoden bzw. Algorithmen dynamisch zur Laufzeit ausgetauscht werden können, um die Wahrnehmung zu optimieren. Somit können die Ergebnisse einer Evaluation des Klangmanagements als Implementierung in die Anwendung einfließen und zur individuellen Anpassung des Klangraumes beitragen.

## Einleitung

Das Projekt wurde aus eigenem Interesse vorgeschlagen und dahingehend formuliert, dass es sowohl einen wissenschaftlichen Anspruch hat, als auch eine explorative Herangehensweise beinhaltet. Grundlagen und Methoden wurden fundiert erhoben, gegeneinander abgewogen und qualitativ bewertet. Der Prozess und die Implementierung wurden wiederum agil und auf Basis des aktuellen Wissensstandes geprägt. Insgeasmt war das Vorgehen ergebnisorientiert, weshalb das vorliegende Dokument als interaktives Playground geschrieben ist. Aus diesem Grund steht die Implementierung im Vordergrund, der erklärende Text dient der Beschreibung, Argumentation, Abwägung und Erklärung von Entscheidungen und der Diskussion. Zudem kann er als roter Faden verstanden werden.

Im Folgenden soll die Arbeit mit einer kurzen Motivation eingeleitet werden. Danach folgt die Beschreibung des Ziels und dem Vorgehen, um das Ziel zu erreichen. Damit eine konkrete Anwendung entwickelt und getestet werden kann, wird ein Kontext definiert, welcher den Rahmen des Anwendungsfalls beschreibt und eingrenzt. Anschließend wird die Organisation des Dokumentes als interaktiver Playground erläutert.

### Motivation

Jeder Mensch verliert im Laufe seines Lebens die Fähigkeit bestimmte Frequenzbereiche zu perzipieren. Die notwendige Hardware und Software, um Manipulationen an Audio-Dateien durchzuführen, tragen viele Menschen in Form vom Smartphones mit sich. Deshalb liegt es Nahe, ausgewählte Audio-Dateien vor dem Konsumieren an die Wahrnehmung des Menschen individuell anzupassen.

### Ziel und Vorgehen

Das primäre Ziel ist es, Möglichkeiten zum Verbessern bzw. Ausbessern des Frequenzverlustes anhand bestehender Audio-Aufnahmen zu evaluieren. Hierfür werden Ansätze in Form von Konzepten und Algorithmen recherchiert, gegeneinander abgewogen und in einer iOS-Anwendung implementiert. Dessen Wirksamkeit, Realisierbarkeit und Performanz im gegebenen Kontext steht hierbei im Vordergrund. Performanz deshalb, weil eine Verarbeitung in Echtzeit angestrebt wird.

Das sekundäre Ziel befasst sich mit Begriffsdefinitionen bezüglich dem Klangmanagment, des Klangraumes und der Klangwahrnehmung. Hierbei soll an die verwandten Begriffe des Farbmangement, Farbraum und Farbwahrnehmung angelehnt werden.

### Kontext

Um die Algorithmen und Konzepte angemessen zu testen, soll ein Nutzungskontext der Anwendung definiert werden. Gleichzeitig dient der Nutzungskontext als Orientierungshilfe bei Entscheidungen und als Rahmen für die Projektgrenzen.

Der Kontext umfasst ein iPhone mit iOS 8 oder höher. Als Audio-Datei dienen Podcasts, die zum größten Teil aus menschlichen Stimmen bestehen. Allerdings wird auch Musik in den verschiedensten Formaten eingespielt, weshalb dieser Frequenzbereich ebenfalls berücksichtigt werden soll.

Bibliotheken und Schnittstellen sind nicht vorgeschrieben. Da die Anwendung in Swift entwickelt werden soll, sollten die verwendeten APIs möglichst selbst in Swift implementiert sein. Alternativ kann ein Objective-C oder sogar C-Bridging für *low-level* Verarbeitung eingesetzt werden.

### Organisation des Dokumentes

Das vorliegende Dokument ist als interaktives Playground organisiert. Während [Kapitel 1](#Einleitung) und [2](#Grundlagen) noch vollständig aus Text bestehen, ist [Kapitel 3](#Theoretische-Überlegungen,-Konzeption-und-Umsetzung) in einem Wechsel zwischen Text und Quellcode organisiert. Der Quellcode wird dynamisch kompiliert, weshalb der Leser Änderungen am Quellcode vornehmen kann, welche anschließend neu kompiliert und ggf. angezeigt werden. Das [letzte Kapitel](#Abschluss) ist ebenfalls klassisch, um das Fazit und die persönliche Einschätzung möglichst präzise, schlüssig und vieldimensional zu gestalten.

Das interaktive Playground ist eine Form der Quellcode-Dokumentation. Demnach steht hierbei der Quellcode im Vordergrund, welcher interaktiv ist, was bedeutet, dass der Quellcode kompiliert, ausgeführt und dessen Ergebnis live angezeigt oder sogar in einem Graph geplottet wird. Der Fließtext dient als roter Faden und erklärt das Vorgehen, die Gedanken und Überlegungen, die Abwägungen von Alternativen und die Begründungen von Entscheidungen. Neben dem interaktiven Quellcode finden sich *Sourcecode-Listings*, welche der iOS-App entstammen. Diese wurde eingefügt, um die Argumentationen mit Quellcode zu führen und Beispiele für die Implementierung zu zeigen.

## Grundlagen

In dem folgenden Abschnitt sollen die Grundlagen geklärt werden. Zu diesem Zweck werden zuerst einige Begriffe erläutert, die in der weiteren Ausarbeitung Verwendung finden sollen.

### Begriffsdefinitionen

Die Erläuterung der Begriffe teilt sich hier in zwei Kategorien auf. Zum einen die allgemeinen Begriffe zum Beschreiben der äußeren Umstände und zum Verdeutlichen der Anwendung. Zum anderen sollen die fachspezifischen Begrifflichkeiten bezüglich der Audio- und die Signalverarbeitung auch an dieser Stelle umschrieben werden.

Zuerst soll sich an dieser Stelle jedoch der allgemeinen Begriffsdefinition gewidmet werden. Zu diesem Zweck werden, wie nachfolgend aufgelistet, drei Begriffe *Klangmanagement*, *Klangraum* und *Klangwahrnehmung* definiert.

* **Klangmanagement:** Unter diesem Begriff soll innerhalb dieser Ausarbeitung die Bearbeitung von Audiosignalen mittels digitaler Signalverarbeitung und deren Algorithmen verstanden werden. Beim Klangmanagement geht es vor allem um eine subjektiv verbesserte Wahrnehmung. In diesem Kontext bedeutet das, dass der Hörer nach der Anwendung des Klangmanagements mehr von der Audiodatei wahrnehmen kann, als es im Originalzustand der Fall wäre.
* **Klangraum:** Hier wurde der Begriff fachlich an den Begriff des Farbraumes angelehnt. Ähnlich des Farbraumes, bei dem es um die vereinheitlichte Darstellung der Farben geht, soll der Klangraum für eine Vergleichbarkeit von Klängen sorgen. Dies ist im Allgemeinen ein schwieriges Unterfangen, da bei Audio viele Parameter einfließen, die beispielsweise bei Monitoren nicht gelten. So ist es unter anderem wichtig, in welchem Raum die Klänge später abgespielt werden sollen und wo sich die Lautsprecher in diesem Raum befinden, sowie der Resonanzkörper in dem die Lautsprecher verbaut wurden.
* **Klangwahrnehmung:** Innerhalb des Ausarbeitungskontextes soll dieser Begriff explizit die *subjektive Wahrnehmung* meinen und damit die natürliche Schallwahrnehmung des Menschen. Subjektiv, da eine objektive Wahrnehmung nicht im Rahmen dieses Guided-Projects vorgenommen werden kann, hierzu fehlen schlicht und einfach die entsprechenden Messgeräte, außerdem ist das Problem einen so subjektiven Wahrnehmungsvorgang wie das Hören einheitlich und objektiv zu messen außerhalb der Möglichkeiten, die im Rahmen dieses Projektes zur Verfügung standen.

Nachdem die übergeordneten Begriffe geklärt wurden, werden nun die technischen Begriffe betrachtet. Hierunter fallen die nachfolgend aufgelisteten.

* **Amplitude:** Unter einer Amplitude wird eine Größeneinheit verstanden, mittels derer sich Schwingung darstellen lässt. Es existieren keine genormten Maßeinheiten, somit wird für diese Ausarbeitung angenommen, dass es sich um positive Integer- bzw. Floatwerte, wie im *linear Pulse Code Modulation (PCM)* Standard verwendet, handelt. Innerhalb dieser Ausarbeitung wird sich nur auf die 32-Bit-Repräsentation des PCM-Standards bezogen, der die Verwendung von Floatwerten vorsieht.
* **Signal:** Die Audiodatei in grafischer bzw. programmatischer Repräsentation. Hierunter fällt die Darstellung innerhalb eines Diagramms oder als Array von diskreten Werten, wie beispielsweise die oben genannten Integer- oder Floatwerten. Im Prinzip ist das Signal eine Darstellungsform, die die Stärke der Schallwellen beschreibt und die an einen Lautsprecher bzw. eine Audioqueue weiter gegeben werden kann.
* **Sample:** Beschreibt einen Messpunkt innerhalb eines Signals. Im Programmatischen typischerweise ein Integer- oder Floatwert, welcher den Amplitudenausschlag beschreibt.
* **Samplerate:** Auch Abtastrate. Beschreibt die Anzahl der erstellten Samples pro Sekunde.
* **Fourier Transformation:** Wandelt das Signal in die spektrale Darstellung. In der spektralen Darstellung anstelle von Amplituden werden Frequenzen dargestellt die als Magnitude beschrieben werden.
* **Magnitude:** Beschreibt den Amplituden ähnlichen Ausschlag eines Signals, jedoch zu einer bestimmten Frequenz, typischerweise in Hertz (Hz) gemessen.
* **Bin:** Beschreibt einen Eintrag des Fourieroutputs. Ein Bin umfasst einen – durch die Länge des Inputs definierten – Frequenzbereich, die ausgegebenen Frequenzbereiche sind untereinander harmonisch.
* **Mapping:** Im Rahmen dieser Ausarbeitung steht Mapping für das Überführen von einem Frequenzbereich in einen anderen.
* **Strategien:** Als Strategie wird im Rahmen dieser Ausarbeitung die Implementierung eines Mappingansatzes bzw. eines Filters oder sonstiger Signalverarbeitung verstanden, um eine Anpassung des Klangraumes und die Klangwahrnehmung zu ermöglichen.

### Auditive Wahrnehmung

Unter auditiver Wahrnehmung wird die Sinneswahrnehmung von auditiven, also akustischen Reizen verstanden. Um diese auditiven Reize aufnehmen zu können, entwickelte sich im Laufe der Evolution das Ohr.

Das Ohr übersetzt Schall über ein komplexes System bestehend aus dem äußeren Gehörgang, der zu einer Membrane führt, auch »**Trommelfell**« genannt. Das Trommelfell überträgt die Schwingung der Luft auf den einen Knochen, welcher »**Hammer**« genannt wird. Die hieraus resultierende Bewegung wird über den »**Amboss**« genannten Knochen weiter an den »**Steigbügel**« geleitet. Dieser überträgt das Signal an die »**Bogengänge**« und die »**Hörschnecke**«, die für die Wahrnehmung des Schalls zuständig sind. Einfach erläutert sorgt eine Flüssigkeit innerhalb der Schnecke dafür, dass die Schallwellen innerhalb der Flüssigkeit übertragen werden und dabei kleine Haare innerhalb der Hörschnecke reizen. Dabei gilt, je weiter das Haar gegen Ende des "Schneckenhauses", desto höher der Ton und desto feiner das Haar. Die Nervenreize, die durch die Bewegung des Haars hervorgerufen werden, gehen dann über den Hörnerv an das Gehirn, welches die Ergebnisse interpretiert.

Es ist nicht schwer zu erkennen, dass dieser Vorgang viel Spiel und Raum für Interpretationen zulässt. Außerdem ist es nicht unwahrscheinlich, dass die Haare, die für höhere Frequenzen zuständig sind, nicht mehr wie gewohnt reagieren bzw. ausfallen. Dies führt im Laufe der Zeit zu einem Hörverlust in den höheren Frequenzbereichen. Aber auch ein Hörverlust in den niederen Frequenzen ist durchaus denkbar. Dieser Umstand erschwert die Beschreibung der Wahrnehmung. Jedoch wird aus diesem Grund auch erst einiges möglich, so ist das Gehirn darauf fokussiert diese Reize zu interpretieren, was ein ständiges Lernen voraussetzt.

Um, wie in diesem Projekt angestrebt, die auditive Wahrnehmung zu verbessern, wurde sich im Rahmen dieser Ausarbeitung vor allem mit dem Übertragen von Frequenzen auf einen anderen Frequenzbereich beschäftigt. Dies kann durchaus für eine subjektive Verschlechterung sorgen, weil sich bestimmte Signale plötzlich anders und je nach Implementierung auch leiser oder lauter anhören. Jedoch gilt zu bedenken, dass so Informationen wieder an das Gehirn weitergeleitet werden, die vorher einfach verloren gegangen wären.  Da das Gehirn diese Reize interpretiert, soll an dieser Stelle die These aufgestellt werden, dass so in angemessener Zeit erlernt werden kann, was diese neuen Reize bedeuten sollen und somit es dem Menschen ermöglicht wird, wieder auf diese Informationen zu reagieren.

Zusammenfassend lässt sich sagen, dass in dieser Ausarbeitung unter auditiver Wahrnehmung der Wahrnehmungsprozess des Menschen verstanden wird, welcher die Interpretation durch das menschliche Gehirn einbezieht. Unter der Verbesserung der auditiven Wahrnehmung soll, gerade in dieser Ausarbeitung, die Anpassung – Klangmanagement – der Audioaufnahme an das Hörvermögen – Klangwahrnehmung – des Benutzers verstanden werden.

### Digitale Signalverarbeitung

Die digitale Signalverarbeitung – engl. Digital Signal Processing (DSP) – ist ein weitreichendes Themengebiet. So umfasst die digitale Signalverarbeitung unter anderem die Verarbeitung von Spannungen in Stromnetzen, die Verarbeitung von digitalen Bildern oder von digitalen Audioformaten, wie z. B. dem linearen PCM Format. Im Rahmen dieser Ausarbeitung soll der Begriff digitale Signalverarbeitung als Synonym für die Verarbeitung digitaler Audioformate dienen. Auch wenn der Begriff Audioverarbeitung augenscheinlich eindeutiger wäre, wird an dieser Stelle die digitale Signalverarbeitung verwendet, da so der Zusammenhang der Algorithmen deutlicher wird.

Insbesondere soll in dieser Ausarbeitung auf die Fouriertransformation eingegangen werden, die ein Signal in dessen Spektrum zerlegt und eine zeitbasierte Darstellung – Liste von Samples – in eine frequenzbasierte Darstellung – Liste von Phasen – überführt. Dieser Vorgang lässt sich am besten durch die Metapher des Prismas erläutern. Die Fouriertransformation, in diesem Projekt durch die Fast-Fouriertransformation realisiert, zerlegt ein Signal, ähnlich einem Prisma auf das Licht fällt, in die einzelnen Spektren, welche beim Licht die Farben sind, die bei einem Regenbogen sichtbar werden. Durch diese Transformation lassen sich im Rahmen der Audioverarbeitung verschiedene Frequenzen analysieren, da auf diese Weise erst die Möglichkeit besteht, diese aus der Audioaufnahme zu extrahieren.

Weitere Techniken, die innerhalb dieses Projektes Verwendung finden, sind High-Pass-Filter und Mappingstrategien. Die High-Pass-Filter werden benötigt, um Störgeräusche aus der Audiodatei zu entfernen. Ein High-Pass-Filter lässt nur Signale oberhalb eines Thresholds durch, wird dieser der Signal-To-Noise-Ratio angepasst, also dem Wert, der ein brauchbares Signal von einem Rauschen oder sonstigen Störgeräusch abgrenzt, können diese Störgeräusche einfach herausgefiltert werden. Die Mappingstrategien werden benötigt, um die Informationen des Signals mit möglichst wenig Verlust auf einen kleineren Frequenzbereich abbilden zu können. Diese werden in einem späteren Kapitel detaillierter erläutert.


## Theoretische Überlegungen, Konzeption und Umsetzung

In diesem Kapitel soll die explorative Herangehensweise beschrieben werden. Hinsichtlich der Projektbeschreibung und den Grundlagen der auditiven Wahrnehmung, wurde das folgende Konzept überlegt:

* **Hörtest**, um den hörbaren Frequenzbereich des Benutzers zu erfassen
* **Extrahieren von Samples in Mono und Stereo**, um die Audio-Datei anschließend angemessen bearbeiten zu können
* **Padding, Windowing und Splitting**, als Vorbereitung für die FFT
* **Manipulation der Samples mithilfe der FFT**, um das Audio-Signal an den Kontext des Benutzers anzupassen
* **Modifizierte Samples als Audio-Datei abspielen**, um das Ergebnis zu hören

Die einzelnen Schritte können so komplex werden, dass an einigen Algorithmen und Methoden zwar eine ausreichende, aber nicht hinreichende Implementierung stattgefunden hat. Die detaillierte Auseinandersetzung mit Audio-Algorithmen ist so umfangreich, dass sie ein eigenes Projekt mit Inhalt füllt. Aus diesem Grund ist die Implementierung der Anwendung als modulares Framework in Swift zum Manipulieren und Abspielen von Audio-Dateien für iOS-Systeme zu verstehen.


Im Folgenden werden die einzelnen Schritte detailliert erklärt, begründet, implementiert und mithilfe des interaktiven Playgrounds vorgeführt.

### Hörtest

Um das Audio-Signal in einen für den Benutzer hörbaren Frequenzbereich anzupassen, muss zunächst der hörbare Frequenzbereich des Benutzers erfasst werden. Hierfür soll ein Hörtest implementiert werden, welcher das für den Menschen hörbare Frequenzspektrum von 0 bis 22000 Hz mit einem akustischen Signal durchläuft. Sobald der Benutzer das Signal perzipiert, drückt er auf eine dafür vorhergesehene Fläche und hält solange gedrückt, bis das Signal nicht mehr zu hören ist. Auf diese Weise erfasst und speichert das System die untere und obere Grenze an hörbaren Frequenzen. Die folgende Abbildung zeigt den Hörtest wie er in der iOS-Anwendung zu sehen ist:

![Hearing Test](hearingtest.png)

Der Hörtest wurde mithilfe von [AudioKit](http://audiokit.io) implementiert. AudioKit liefert eine umfangreiche Bibliothek für das Erzeugen und Verarbeiten von Audio auf Basis von Apples APIs. Glücklicherweise haben die Entwickler von AudioKit bereits ein Bridging Projekt von Objective-C auf Swift bereitgestellt, weshalb die Anbindung problemlos verlief.

Im Folgenden wird eine gekürzte Implementierung des *HearingTestViewController* vorgestellt. Dieser erzeugt ein *ToneWidget*, welcher im Verlauf von 60 Sekunden ein Signal von 0 bis 22000 Hz generiert. Ein Blick in *Constants* zeigt die Konfiguration des Hörtests.

    struct Constants {
        static let StopToneGeneratorNotification = "stopToneGeneratorNotification"
        
        static let maxFrequency = "maxFrequency"
        static let minFrequency = "minFrequency"
        
        static let amplitude: Float = 0.25
        static let numInstruments = 1
        static let frequencyScale: Float = 22000
    }

Theoretisch lässt sich die Anzahl der *ToneWidgets* mit *numInstruments* steuern, um einen dedizierten Hörtest für beide Ohren durchzuführen. Aus diesem Grund wurde ein Array von ToneWidget angelegt. Des Weiteren lässt sich die Amplitude über *amplitude* ansteuern. In der *viewDidLoad* Funktion werden ToneWidget und SoundGenerator angelegt. Die *start* Funktion lässt den Hörtest solange laufen, wie der Benutzer auf das ToneWidget drückt. Erst wenn kein Ton mehr zu hören ist, lässt der Benutzer los, wodurch die *stop* Funktion aufgerufen wird. Da die Gesten im ToneWidget implementiert sind, ruft das Widget über das Notification-Pattern die *onStartAndStop* Funktion auf. Diese speichert die übergebene min- und max-Frequenz. Diese beiden Schranken geben den vom Benutzer hörbaren Frequenzbereich an.

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
       
Im Rahmen des Prototypen wurde lediglich der Hörtest ohne Berücksichtung von Stereo implementiert. Des Weiteren wird zwar das Regulieren der Amplitude ermöglicht, allerdings nicht in Relation zur Frequenz erfasst. Für die Validierung des Konzeptes wird lediglich der vom Benutzer hörbare Frequenzbereich benötigt. Die Granularität hat keine Auswirkung auf das Vorgehen. Die oben gezeigte Implementierung liefert hierfür dennoch die notwendigen Schnittstellen.

### Extrahieren von Samples aus einer Audio-Datei in Mono und Stereo
Im Rahmen des Projektes wurde innerhalb des KlangraumKit-Frameworks die Klasse *AudioFile* angelegt, welche als Hilfsklasse fungiert, um das Lesen und Schreiben von Audiodateien in C als Funktionen in Swift zu wrappen. Die Funktionen innerhalb der Klasse wurden funktional implementiert und bieten ein monadisches Errorhandling (ähnlich wie das *Try* in Scala), um zum einen das Debugging zu erleichtern und zum anderen eine Möglichkeit zu haben mit IO-Fehlern typsicher umzugehen.

Zum Lesen einer Audiodatei dient die Funktion *readAudioFile(String) -> Failable*, die nachfolgend aufgeführt ist. Um eine Audiodatei zu lesen, muss dieser Funktion nur der Pfad zu der gewünschten Datei als String übergeben werden. Durch die Verwendung des *AVFoundation*-Frameworks können alle Dateiformate gelesen werden, die von iOS nativ unterstützt werden.

    func readAudioFile(path: String) -> Failable<AVAudioPCMBuffer> {
        // setup variables
        let url = NSURL(string: path)
        do {
            let audioFile = try AVAudioFile(forReading: url!)
            let audioFileFormat = audioFile.processingFormat
            let audioFileFrameCount = UInt32(audioFile.length)
            let pcmBuffer = AVAudioPCMBuffer(PCMFormat: audioFileFormat, frameCapacity: audioFileFrameCount)
            // read audiofiles in buffer
            do {
                try audioFile.readIntoBuffer(pcmBuffer)
            } catch let error as NSError {
                return Failable.Failure("readAudioFile()::: Error while read File to Buffer (Error: \(error))")
            }
            return Failable.Success(Box(pcmBuffer))
        }
        catch let error {
            return Failable.Failure("readAudioFile()::: Error with URL (Error: \(error)")
        }
    }

Im Wesentlichen führt die Funktion vier wichtige Schritte aus. Erstens wird der Pfad als String in eine URL umgewandelt. Danach wird die Audiodatei aus dem Dateisystem geladen, woraufhin als Drittes ein *AVAudioPCMBuffer* angelegt wird, welcher den Inhalt der Datei aufnehmen soll. Die Klasse *AVAudioPCMBuffer* stellt eine spezielle Form des *AudioBuffer* dar, welche den Inhalt einer Audiodatei automatisch in das *linear Puls-Code-Modulation (PCM)* Format konvertiert.

Wie weiter oben genannt ist die Klasse *AudioFile* mit einem Errorhandling ausgestattet, diese wurde mittels *Failable* implementiert. Failable ist eine Klasse, die mittels einer Monade das vorhergehende *Result* evaluieren kann und bei Erfolg an eine weitere Funktion mittels des dafür definierten *-->* Operators weitergeben kann. Der Operater komponiert verschiedene Failables, solange sie *unboxed* werden können. Falls die Funktion nicht wie geplant läuft, wird durch den *Failure*-Case die weitere Ausführung unterbrochen und die Fehlermeldung weiter gereicht. Die Implementierung dieses Konstrukts wird nachfolgend gezeigt.

    enum Failable<T> {

        case Success(Box<T>)
        case Failure(String)

        public func dematerialize() -> T? {
            switch self {
                case .Success(let box):
                    return box.value
                case .Failure(let error):
                    return nil
            }
        }
    }

    infix operator --> { associativity left }
    public func --><In, Out>(left: Failable<In>, fn: In -> Failable<Out>) -> Failable<Out> {
        switch left {
            case .Success(let box):
                return fn(box.value)
            case .Failure(let error):
                return .Failure(error)
        }
    }

Die Funktion *dematerialize() -> T* wird zum Auslesen des Wertes benötigt. Wie in der Implementierung zu sehen ist, handelt es sich bei dem Returnwert um einen *Optional*, was bedeutet, dass mittels der in Swift eingebauten *if let*-Schreibweise die Ergebnisse einfach evaluiert werden können (Success- und Failure-Handling). Da im Erfolgsfall der Wert des Identity-Monade zurückgegeben wird, macht die Einbindung des Failable-Enums in andere Projekte kaum Aufwand und verbessert, nach Meinung der Autoren, die Lesbarkeit und das Verhalten im Fehlerfall, vor allem bei einem funktionalen Programmierstil.

Zurück zu der *readAudioFile*-Funktion, die im erwarteten Fall einen *Failable* mit dem *AudioBuffer* als Inhalt liefert. Da die weitere Anwendung die Daten im Floatformat erwartet, muss dieser nun in ein Floatarray umgewandelt werden. Hierfür wird die Funktion *convertToFloatSamples(AVAudioPCMBuffer) -> Failable* verwendet, welche ebenfalls in der Klasse AudioFile implementiert ist und im Folgenden gezeigt wird.

    func convertToFloatSamples(pcmBuffer: AVAudioPCMBuffer) -> Failable<[Float]> {
        // generate
        let samples:[Float] = (0 ..< Int(pcmBuffer.frameLength)).map { pcmBuffer.floatChannelData.memory[$0] }

        if samples.isEmpty {
            return Failable.Failure("convertToFloatSamples()::: Error while converting to float samples")
        } else {
            return Failable.Success(Box(samples))
        }
    }

Durch die *map*-Funktion werden die Werte in ein Array transformiert. Dies geschieht durch den direkten Zugriff auf den Speicherbereich, in dem sich die Floatdaten befinden, deutlich zu erkennen durch den Aufruf *pcmBuffer.floatChannelData.memory[$0]*. Dieser etwas komplizierte Zugriff ist auf die nachträglich hinzugefügte Kompatibilität zwischen Swift und C zurückzuführen. Wenn das Mapping erfolgreich verlief und die im Buffer vorhandenen Daten in ein Array transformiert wurden, können die Samples einfach per Zugriff auf das Array gelesen und manipuliert werden.

Im Rahmen des Projektes wurde auch eine Stereo Kompatibilität implementiert. Zu diesem Zweck kann die Funktion *splitToInterleaved([Float]) -> Failable<[String: [Float]]>* verwendet werden, welche nachfolgend aufgezeigt und erläutert wird.

    func splitToInterleaved(samples1D: [Float]) -> Failable<[String: [Float]]> {
        // initialize two arrays for left and right audiosamples, append left an right samples to arrays (scheme left, right)
        let left: [Float] = 0.stride(through: samples1D.count - 1, by: 2).map { samples1D[$0] }
        let right: [Float] = 1.stride(through: samples1D.count - 1, by: 2).map { samples1D[$0] }

        if left.isEmpty || right.isEmpty {
            return Failable.Failure("splitToInterleaved():::could not seperate left and right Samples")
        } else {
            return Failable.Success( Box(["left":left, "right":right]) )
        }
    }

Bei Stereoaudio werden die Samples *Interleaved* repräsentiert. Bei einer Interleaved-Repräsentation werden die Samples, wie bei der Mono Darstellung, in einem eindimensionalen Array gespeichert und dargestellt, wobei der linke und der rechte Audiokanal durch die geraden bzw. ungerade Indizes dargestellt werden. Wie in der vorhergehenden Implementierung zu sehen, wird das ursprüngliche Signal in zwei Arrays aufgeteilt, eins für die linke Tonspur und eins für die rechte. Dies geschieht mithilfe der *stride*-Funktion, welche wie ein Iterator, bei dem man die Schrittweite der Iteration angeben kann, funktioniert. Die Transformation in ein Array erfolgt wie bei *convertToFloatSamples()* mittels der *map*-Funktion. Bei der weiteren Verarbeitung eines Stereosignals gilt zu beachten, dass bei richtiger Ausführung ein Dictionary (Map) erstellt wird, um auf die jeweiligen Audiospuren mittels der Keys »left« oder »right« zugreifen zu können.

Zur Verdeutlichung des Ablaufes soll nachfolgender Code demonstrieren, wie Audiosamples gelesen werden können. */
// file and path
let file = "alex.m4a"
let path = String(NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent(file))

// setup AudioFile
let af = AudioFile()

// compose functions in order to extract float samples from given file
let interleavedSamples = (af.readAudioFile(path) --> af.convertToFloatSamples --> af.splitToInterleaved).dematerialize()

// plot left samples
interleavedSamples?["left"]?.map{ $0 }
/*:

Wie hier zu sehen, wird erst eine Audiodatei gelesen, diese wird dann in ein Array aus Float konvertiert und mittels *splitToInterleaved* in das oben bereits beschriebene Dictionary umgewandelt. Nach Vollendung der Funktionen kann mittels der *dematerialize()-Funktion* auf das Dictionary zugegriffen werden, wie im Plot zu sehen ist.

### Padding, Windowing und Splitting
Nachdem nun die Samples aus einer Audiodatei extrahiert werden können, soll in diesem Abschnitt etwas genauer auf die Hintergründe der FFT unterstützenden Techniken eingegangen werden, um im nächsten Kapitel auf die Implementierung der FFT-Klasse einzugehen. Zu diesem Zweck wird hier genauer auf die folgenden drei Themen **Padding**, **Windowing** und **Splitting** eingegangen. Um den logischen Ablauf zu wahren, wird zuerst das Splitting betrachtet, darauf folgend das Padding und zuletzt das Windowing.

Beim Splitting geht es um die Aufteilung der Samples, die mittels der Fast-Fouriertransformation in die spektrale Darstellung aufgeteilt werden sollen. Der erste naive Ansatz lässt Entwickler dazu verleiten, die gesamten Samples in die FFT zu übergeben, allerdings gehen so die zeitlichen Informationen verloren. Im Rahmen der spektralen Analyse sind vor allem die Spektren und deren Veränderung im Laufe der Zeit von Interesse. Da die FFT als Resultat die Verteilung der Schallwellen in bestimmten Frequenzbereichen darstellt, würde die Übergabe aller Samples nur die in der Audioaufnahme vorhandenen Frequenzen aufzeigen. Wie aus dieser Erläuterung zu sehen, sollten die Samples in kleinere Subarrays aufgeteilt werden, was auf das einzelne Array auch einen Performancevorteil hat, die Größe dieser Arrays ist abhängig vom Verwendungszweck. Des Weiteren können diese Subarrays parallelisiert werden, da die FFT zunächst keine Abhängigkeiten zu den anderen Subarrays hat. Das Zusammensetzen ist allerdings schwieriger, weil die Reihenfolge der Samples wichtig ist. Bei einfachen Audioaufnahmen, wie beispielsweise Radiosendungen ohne Musik, reicht eine Arraygröße von ca. 1024 Samples, also einem Zeitfenster von etwa 43 Millisekunden der originalen Audiodatei. Bei komplexeren Audiospuren wie Musik sollte ein solches Subarray eine Größe von 2048 Samples haben. Wie zu Beginn des Absatzes erwähnt, können mittels dieser Technik die spektralen Veränderungen über einen Zeitraum verglichen werden. Dies geschieht durch einfaches Vergleichen von nebeneinanderliegenden Subarrays. Im Folgenden soll die Implementierung des Splittings gezeigt werden.

    func prepare(samples: [Float], steppingBy steps: Int) -> [[Float]] {
        var tmp = samples

        let count = tmp.count
        let length = count / steps

        var splitSamples = [[Float]](count: length, repeatedValue: [0.0])
        var j = 0

        for i in 0..<splitSamples.count {
            let first = j * steps
            let last = first + (steps - 1)
            splitSamples[i] = Array(tmp[first...last])
            j++
        }

        return splitSamples
    }

Die Funktion hat eine Signatur von *prepare([Float], Int) -> [[Float]]*, wobei das Floatarray die Samples sind und die Int Variable die Größe der Subarrays definiert. Das Ergebnis der Funktion ist ein Array von Floatarrays, bei dem die internen Arrays so groß sind, wie es der Int Parameter vorschreibt. Das Rekonstruieren des ursprünglichen Arrays aus den vielen Subarrays kann mithilfe der *flatten*-Funktion erfolgen: */
// setup
let steps = 1024
let s = (0...steps * 2).map{ Float($0) }

// split
let splitted = prepare(s, steppingBy: steps)

// use
splitted.flatMap { subArray in
    // do something with subArray
    return subArray
}

// flat to origin
let flatted = Array(splitted.flatten())
/*:

Padding ist im Wesentlichen das Auffüllen der oben beschriebenen Subarrays, da die Fourier Transformation eine definierte Länge benötigt um zufriedenstellende Ergebnisse zu liefern. Dies kann von Nöten sein, da die Audioaufnahmen nicht zwingend eine Vielzahl von 1024 bzw. 2048 sein muss. Um die Fouriertransformation trotzdem weiter durchführen zu können und alle Daten, die potenziell relevant sind zu erfassen, kann bei dem letzten Subarray ein *Zero-Padding* vorgenommen werden. 

Dieses Padding verändert nicht die spektralen Informationen, da die Null bei der Sample-Repräsentation für die Abwesenheit von Amplitudenausschlägen steht und somit die Frequenzen nicht verändert. Dadurch entspricht *splitting.count % 1024* immer gleich *0*. Im Folgenden die Implementierung der *addZeroPadding([Float], Int) -> [Float]*-Funktion, welche die Samples als Floatarray und den aufzufüllenden Faktor als Int entgegennimmt und das aufgefüllte Floatarray zurückgibt.

    func addZeroPadding(a:[Float], whileModulo mod: Int) -> [Float] {
        var tmp = a

        while tmp.count % mod != 0 {
            tmp.append(0.0)
        }

        return tmp
    }

Zum Abschluss dieses Abschnittes soll noch kurz auf die Verwendung von *Windowing* Methoden eingegangen werden. Der Grund für das Windowing liegt in der Eigenschaft der Fouriertransformation, die ein Signal ähnlich einem Prisma in die harmonischen Spektren zerlegt. Harmonisch deutet bereits darauf hin, dass nicht sämtliche Frequenzen abgebildet werden können. Frequenzen, die sich zwischen Harmonien befinden, können ggf. vernachlässigt werden. 

Um diesem Effekt entgegenzuwirken, soll eine Windowfunktion auf das Audiosignal angewendet werden, bevor es mithilfe der FFT transformiert wird. Windowing sorgt für eine geringe Veränderung bzw. Überschneidung der Frequenzen. Diese Veränderung hat vor allem den Vorteil, dass sie wieder leicht aus dem Signal herausgerechnet werden kann. Durch diese Manipulation ist es möglich, mehr harmonische Frequenzen mittels der FFT zu erfassen, da die Zusammensetzungen der Frequenzen innerhalb der Windows besser zueinanderpassen. Im Rahmen dieses Projektes wurden sowohl das *Hamming*- als auch das *Hanning*-Windowing implementiert und ausprobiert. Zusammenfassend erhöht das Windowing die Brauchbarkeit der FFT-Ergebnisse. Die Implementierung Hamming- und Hanning-Window-Funktion mithilfe der vDSP-API und das Anwenden und Zurückrechnen einer der beiden Funktionen sieht folgendermaßen aus:

    import Accelerate

    func hanning(length: Int) -> [Float] {
        var window = [Float](count: length, repeatedValue: 0)
        vDSP_hann_window( &window, vDSP_Length(window.count), 0 )
        return window
    }

    func hamming(length: Int) -> [Float] {
        var window = [Float](count: length, repeatedValue: 0)
        vDSP_hamm_window( &window, vDSP_Length(window.count), 0 )
        return window
    } */

// window function
let windowedHanning: [Float] = hanning(s.count)

// apply window function on samples
let appliedHanning = s * windowedHanning

// unwindow
let unwindowedHanning = appliedHanning / windowedHanning
/*:

### Manipulation der Samples mithilfe der FFT

Der Kern der Anwendung befasst sich mit der FFT. Die Implementierung muss in der Lage sein, eingehende Samples von einer zeitbasierten Darstellung in eine frequenzbasierte Darstellung zu überführen. In der frequenzbasierten Darstellung liegen die Daten als komplexe Zahlen vor. Die Anwendung muss ebenfalls in der Lage sein, aus den komplexen Zahlen reale Zahlen oder Polarkoordinaten zu extrahieren. Mithilfe dieser Operationen wird das Signal bearbeitet. Anschließend muss eine inverse FFT implementiert werden, welche die komplexen Zahlen in Samples überführt. Das Manipulieren des Signals sollte modular implementiert werden, sodass man nachträglich Audio-Algorithmen hinzufügen und zur Laufzeit austauschen kann.

Die API zum Umgang mit der FFT sollte die oben genannten Anforderungen erfüllen. Im Kontext von iOS bietet Apple selbst eine API zur digitalen Signalverarbeitung namens [vDSP](https://developer.apple.com/library/prerelease/ios/documentation/Accelerate/Reference/vDSPRef/index.html) an. vDSP nutzt das [Accelerate Framework](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/AccelerateFWRef/index.html#other), welches eine C-API zum Verarbeiten von Vektoren, Matrizen, digitalen Signalen, Bildern usw. anbietet. Einen leichtgewichtigen Wrapper um die *low-level* APIs gibt es nicht, vor allem nicht für Swift. Aus diesem Grund kommt eine weitere Herausforderung hinzu: die Nutzung von C-artigen, adress- und pointerbasierten Funktionen in einer modernen Programmiersprache, die aus der Intention heraus entwickelt wurde, seinen C-Balast abzuwerfen. Unabhängig davon, fällt die Wahl auf vDSP und dem Accelerate Framework, da beide APIs von Apple für iOS Systeme angeboten werden, um digitale Signalverarbeitung zu ermöglichen. Des Weiteren scheint die Benutzung beider APIs eher mit Swift zu harmonieren, als eine andere reine C oder C++ API. Das wichtige Kriterium ist jedoch, dass beide APIs laut dem [vDSP Reference Guide](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/vDSPRef/index.html#//apple_ref/doc/uid/TP40009464) die oben genannten Anforderungen erfüllen.

#### FFT Datenstrukturen

Die Implementierung der FFT-Komponente beginnt mit den Datenstrukturen. Die Funktionen der vDSP API sind so aufgebaut, dass sie, neben primitiven Parametern wie *Int* und *Double*, *UsafePointer* und *UnsafeMutablePointer* entgegennehmen oder zurückgeben:

    import Accelerate

    func vDSP_zvmags(__A: UnsafePointer<DSPSplitComplex>, _ __IA: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length) {}
    func vDSP_mmul(__A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __M: vDSP_Length, _ __N: vDSP_Length, _ __P: vDSP_Length) {}

Die erste Funktion extrahiert die *Magnitudes* aus einer komplexen Zahl. Die zweite Funktion multipliziert zwei Arrays, die wiederum Magnitudes sein können. UnsafePointer und UnsafeMutablePointer werden benutzt, um mit den Adressen der Variablen (Pointer) zu arbeiten. Alle vDSP Funktionen sind C-artig implementiert. Sie nehmen die Adresse einer Variable entgegen, manipulieren den Wert und geben somit *keinen* Wert zurück, dies kann zu *side effects* führen.

Um im Kontext einer modernen, multiparadigmen Programmiersprache mit solch einer Art von Funktionen zu arbeiten, wird die Benutzung der vDSP API mithilfe von geeigneten Datenstrukturen und Funktionen abstrahiert. Zunächst werden die Datenstrukturen vorgestellt. Im übernächsten Kapitel (Operationen auf komplexen Zahlen) werden die Funktionen vorgestellt.

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

Als erstes wird die Struktur einer komplexen Zahl beschrieben, welche aus einer realen und einer imaginären Zahl besteht. Der Typ *T* kann wahlweise *Double* oder *Float* sein. Ein *SplitComplexVector* beschreibt eine Menge von komplexen Zahlen, wobei der reale und imaginäre Anteil getrennt betrachtet werden. Des Weiteren wird der Zugriff auf den SplitComplexVector mithilfe des Array-Subscripts vereinfacht: */
let vector = SplitComplexVector<Float>(count: 10, repeatedValue: Complex<Float>(real: 0, imag: 0))
let first = vector[0] // subscript, element an der Stelle 0
/*:

#### Die FFT Klasse

Gemäß den oben genannten Anforderungen muss die FFT Implementierung eine Hin- und Rücktransformation ermöglichen:

    protocol Transformation {
        
        func forward() -> SplitComplexVector<Float>
        
        func inverse(x: SplitComplexVector<Float>) -> [Float]
    }

Das Protocol definiert die Transformationen von **real -> forward -> complex -> inverse -> real**. Der Eingabeparameter (real) sind die Samples als Array vom Typ Float, welcher aber hier nicht übergeben, sondern als Instanzvariable bezogen wird. Die Forward-Funktion gibt einen SplitComplexVector vom Typ Float zurück, welcher als Eingabeparameter für die Inverse-Funktion verwendet wird, welche wiederum Samples als Floatarray zurückgibt. Die komplexen Zahlen zwischen Forward und Inverse werden für Manipulationen am Signal verwendet, welches im übernächsten Kapitel (Strategien zum Manipulieren der Magnitudes) beschrieben wird.

Die [vDSP API](https://developer.apple.com/library/mac/documentation/Performance/Conceptual/vDSP_Programming_Guide/UsingFourierTransforms/UsingFourierTransforms.html#//apple_ref/doc/uid/TP40005147-CH3-SW1) von Apple benötigt für die FFT ein *FFT-Setup* und einige weiteren Konstanten. Die notwendigen Parameter werden für die aufrufende Instanz über den Konstruktor abstrahiert. Der Konstruktor selbst benötigt lediglich die Samples als Floatarray:

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

Die beiden Transformationsfunktionen werden implementiert, indem die Klasse FFT um das obige *Transformation*-Protocol erweitert wird :

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

Die Forward-Funktion erzeugt sich zunächst einen *SplitComplexVector* mit der Größe von *Samples/2*, weil die FFT aus *N* Samples ein N/2 großes Array erzeugt, die andere Hälfte der Samples ist redundant. Der SplitComplexVector wird mit komplexen Zahlen, 0+0i, aufgefüllt und anschließend als Pointer an den *DSPSplitComplex* übergeben, welcher von der vDSP API als Quelle der FFT Daten verwendet wird. Um die Werte aus den Samples in den DSPSplitComplex zu kopieren, wird die vDSP-Funktion *vDSP_ctoz* verwendet. Da alle vDSP-Funktionen mit Pointern und Adressen arbeiten, muss mithilfe der *withUnsafeBufferPointer*-Funktion die Adresse der Samples ausgelesen und als *UnsafePointer* vom Typ *<DSPComplex>* der eigentlichen *vDSP_ctoz*-Funktion übergeben werden. Auf diese Weise wird die Adresse des aktuellen Samples als *xAsComplex* übergeben und dessen dereferenzierter Wert in den Pointer von *dspSplitComplex* geschrieben. Die letzte Zeile der Closure führt die eigentliche FFT aus. vDSP sieht insgesamt 12 Funktionen für die Fourier Transformation vor, welche sich beispielsweise darin unterscheiden, ob eine 1D oder 2D Transformation durchgeführt werden soll. Des Weiteren wird unterschieden, ob das Ergebnis In-Place oder Out-of-Place und als Float oder Double zurückgegeben werden soll. Aufgrund der zuvor definierten Anforderungen an die FFT, wird die *vDSP_fft_zrip*-Funktion verwendet, welche eine In-Place Transformation mit einfacher Präzision (Float) durchführt. Als Parameter werden das in der Init erstellte FFT-Setup, die Adresse von *dspSplitComplex*, die Länge und die Richtung (Forward oder Inverse) übergeben. Die *vDSP_fft_zrip*-Funktion modifiziert die *dspSplitComplex* Variable mit dem Ergebnis der FFT (side effect). Da sowohl der reale als auch der imaginäre Anteil von DSPSplitComplex mit der Adresse von SplitComplexVector initialisiert wurde, gibt die Forward-Funktion nicht den Datentyp von vDSP (DSPSplitComplex), sondern das selbst geschriebene Hilfstruct (SplitComplexVector) zurück. Auf diese Weise ist die Implementierung der FFT-Klasse nicht abhängig von der vDSP API. Bei Bedarf kann die low-level API ausgewechselt werden, ohne das aufrufende Instanzen, die das Transformation-Protocol verwenden, geändert werden müssen.

Im Folgenden wird eine Forward-Transformation mithilfe des Transformation-Protocol am Beispiel einer Sinus-Funktion durchgeführt. Zunächst das Erzeugen der Sinus-Funktion: */
import Accelerate

private func sin(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvsinf(&results, x, [Int32(x.count)])
    
    return results
}

// parameters
let count = 64
let frequency: Float = 4.0
let amplitude: Float = 3.0

// build sine function
let sineValues = (0..<count).map { Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
let samples: [Float] = sin(sineValues)

// plot sine function
samples.map{ $0 }
/*: 

Mithilfe der Map-Funktion wird eine Sinus-Funktion mit 64 Samples erzeugt und anschließend gezeichnet. Die Samples sollen nun als Basis für die FFT-Forward-Funktion verwendet werden. Das Ergebnis wird ebenfalls gezeichnet: */
private func magnitudes( var x: SplitComplexVector<Float> ) -> [Float] {
    var magnitudes = [Float]( count: x.count, repeatedValue: 0 )
    
    let dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    for i in 0..<x.count {
        magnitudes[i] = sqrt(dspSplitComplex.realp[i] * dspSplitComplex.realp[i] + dspSplitComplex.imagp[i] * dspSplitComplex.imagp[i])
    }
    
    return magnitudes
}

// perform forward
let fft = FFT(initWithSamples: samples)
let forward = fft.forward()

// plot magnitudes 
magnitudes(forward).map{ $0 }

/*: 

Die Funktion *magnitudes<A, B>(A) -> B* ist eine Hilfsfunktion, die erst im nächsten Unterkapitel besprochen wird. Sie wird benötigt, um die Magnitudes aus den komplexen Zahlen zu extrahieren, die anschließend gezeichnet werden. Im Folgenden sollen die komplexen Zahlen mithilfe der Inverse-Funktion wieder in das Ausgangssignal zurückgerechnet und ebenfalls gezeichnet werden: */

// perform inverse
let inverse = fft.inverse(forward)

// plot inverse
inverse.map{ $0 }

/*:

#### Operationen auf komplexen Zahlen

Wie die Magnitudes-Funktion gezeigt hat, werden einige weitere Funktionen benötigt, welche auf den Daten der FFT operieren. Da die meisten dieser Funktionen intern die Funktionen der vDSP API verwenden, um beispielsweise aus komplexen Zahlen (DSPSplitComplex) die Polarkoordinaten zu extrahieren, wurden die Funktionen wiederum in Swift Funktionen gewrapped. Diese Funktionen in Swift haben meistens eine Signatur von *func<A>(SplitComplexVector<A>) -> Array<A>*, um erneut nicht von der vDSP API abhängig zu sein. Auch hier kann die Bibliothek für die digitale Signalverarbeitung ausgetauscht werden, ohne das Änderungen bei der aufrufenden Instanz durchgeführt werden müssen.

Neben der Magnitudes-Funktion werden noch die Folgenden wichtigen Funktionen vorgestellt: */
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

// perform polar
let polar = polarCoordinates(forward)

// plot magnitudes and phase
polar.mag.map{ $0 }
polar.phase.map{ $0 }

func maxHz(samples: [Float], rate: Int) -> Float {
    let length = samples.count / 2
    
    var max: Float = 0.0
    var maxIndex = vDSP_Length(0)
    vDSP_maxvi(samples, 1, &max, &maxIndex, vDSP_Length(length));
    
    return (Float(maxIndex) / Float(length)) * (Float(rate) / 2)
}

// perform and show frequency
maxHz(samples, rate: count)

/*:

Die erste Funktion, *normalizedMagnitudes<A, B>(A) -> B*, berechnet die Magnitudes einer komplexen Zahl *A* mithilfe der *vDSP_zvmagsD*-Funktion, im Gegensatz zur bereits vorgestellten *magnitudes<A, B>(A) -> B*-Funktion, welche ohne die vDSP API auskommt. Des Weiteren werden die Magnitudes normalisiert, weil *vDSP_zvmags* die quadrierten Magnitudes des komplexen Vektors zurückgibt. Auch die Funktion *abs<A, B>(A) -> B* macht letztlich das Gleiche wie *magnitudes* und *normalizedMagnitudes*, außer das Normalisieren. Eine neue Funktion ist *polarCoordinates<A, B>(A) -> (B, B)*, welche die Polarkoordinaten als Tupel zurückgibt. Hierbei beschreiben Magnitudes den Abstand zu 0 und die Phase den Winkel zur Koordinate. Zuletzt sei noch die Funktion *maxHz<A, B, C>(A, B) -> C* erwähnt, welche die Frequenz der übergebenen Samples *A* unter Berücksichtigung der Samplingrate *B* mithilfe der *vDSP_maxvi*-Funktion berechnet. Die Funktion wird am Beispiel der Sinus-Funktion aufgerufen und gibt die Frequenz 4 zurück. Angesichts der Zeile *let frequency: Float = 4.0* stimmt das Ergebnis.

#### Strategien zum Manipulieren der Magnitudes

Bislang verfügt die FFT-Klasse lediglich über die Funktion der Hin- und Rücktransformation. Allerdings wird eine Implementierung benötigt, die eine Manipulation des Signales ermöglicht. Genauer gesagt müssen zwischen der Forward- und Inverse-Funktion die Magnitudes aus den komplexen Zahlen extrahiert, manipuliert und anschließend wieder als komplexe Zahlen zurückgegeben werden. Demnach hat die Funktion eine Signatur von *apply<A>(A) -> A*, wobei A vom Typ *Array(Float)* oder *Array(Double)* sein sollte.

Um mehrere Strategien für das Manipulieren von Daten zu ermöglichen und diese dynamisch zur Laufzeit hinzufügen zu können, wird ein *FilterStrategy*-Protocol mit der oben genannten Funktions-Signatur deklariert. Des Weiteren wird ein *Filterable*-Protocol definiert, welcher der FFT-Klasse ermöglicht, eine Array von Filter-Strategien zu setzen, um mehrere Strategien funktional zu komponieren. Hierbei liegen alle Implementierungen von FilterStrategy als *Strategy-Pattern* vor. Die modulare Implementierung der FFT-Klasse erlaubt ein dynamisches Hinzufügen und Komponieren der Strategien. Auf die Weise kann beispielsweise erst eine *Noise-Reduction* erfolgen, bevor das Signal in einen bestimmten Frequenzbereich gemapped wird. Selbst diese beiden Implementierungen können durch einen verbesserten Noise-Reduction- oder Mapping-Algorithmus ausgetauscht werden.

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

Über einen weiteren Konstruktor wird ein Array von *FilterStrategy* übergeben. Als nächstes folgt die Implementierung der Funktion, welche die Magnitudes aus den komplexen Zahlen extrahiert und die *apply-Funktion* aller Filter-Strategies komponiert. Die Funktion setzt bei **complex** zwischen **forward -> complex** und **complex -> inverse** an und hat demnach eine Signatur von *A -> A* wobei A ein SplitComplexVector vom Typ Float ist. Die Implementierung dieser Funktion erfolgt, indem die FFT-Klasse erweitert wird.

    extension FFT {
        
        func applyStrategy(x: SplitComplexVector<Float>) -> SplitComplexVector<Float> {
            var splitComplex = x
            let result = [Float](count: length, repeatedValue: 0)
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
                vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
            }
            
            let applied = strategy.reduce(result) { values, strategy in // composing strategies
                return strategy.apply(values)
            }
            
            applied.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
                let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
                vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
            }
            
            return splitComplex
        }
    }

Vor und nach dem Anwenden der Strategien müssen die komplexen Zahlen, ähnlich wie bei der Forward- und Inverse-Funktion, zunächst mithilfe der *withUnsafeBufferPointer*-Funktion extrahiert, aufbereitet und als *DSPSplitComplex* zurückgegeben werden. Das eigentliche Anwenden der Strategien erfolgt mithilfe der funktionalen Reduce-Funktion. Diese wird – über Umwege – mit den Werten des Übergabeparameters *x*, den Magnitudes der komplexen Zahlen aus der Forward-Funktion, intialisiert. Basierend auf diesem Startwert wird für jede Strategy *strategy* die *apply*-Funktion mit dem Ergebnis des vorherigen Durchlaufs *values* aufgerufen. Auf diese Weise werden alle Strategien komponiert und das Ergebnis mithilfe der *withUnsafeBufferPointer*-Funktion als *SplitComplexVector* vom Typ Float zurückgegeben.

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
// setup
let withStrategies = FFT(initWithSamples: samples, andStrategy: [DoubleStrategy(), NoStrategy(), TrippleStrategy()])

// perform fft-stack
let forardWithS = withStrategies.forward()
let applied = withStrategies.applyStrategy(forardWithS)
let inverseWithS = withStrategies.inverse(applied)

// plot inverse
inverseWithS.map{ $0 }

// compare compused results
maxOf(samples)
maxOf(inverseWithS)
/*: 

Auch wenn die oben gezeichnete modifizierte Sinus-Funktion sich opisch nicht von der am Anfang gezeigten Sinus-Funktion unterscheidet, ist das Entscheidende der *max*-Funktion zu entnehmen. Während der höchste Wert der originalen Sinus-Samples 1 beträgt, ist es bei dem modifizierten Signal eine 6, weil 1 (original) * 2 (DoubleStrategy) * 3 (TrippleStrategy) = 6 ergibt.

Um den Aufruf von **forward -> apply -> inverse** etwas angenehmer zu gestalten, wurde ein überladener Infix Operator *-->* eingeführt, welcher das Ergebnis von *Left* als Übergabeparameter von *Right* komponiert. Demnach können die folgenden zwei Signaturen

* --><A, B>(A, A -> B) -> B und 
* --><A>(A, A -> A) -> A

auftreten, weil die Überführung entweder von *Array<Float>* zu *Array<Float>*, *SplitComplexVector<Float>* zu *SplitComplexVector<Float>* oder von *SplitComplexVector<Float>* zu *Array<Float>* erfolgt. Intern wird das Ergebnis der linken Funktion der rechten Funktion übergeben und dessen Ergebnis als nächstes *Links* zurückgegeben: 

    infix operator --> { associativity left }

    func --><A, B>(left: A, right: A -> B) -> B {
        return right(left)
    }

    func --><A>(left: A, right: A -> A) -> A {
        return right(left)
    }
*/
// setup
let overload = FFT(initWithSamples: samples, andStrategy: [DoubleStrategy(), NoStrategy(), TrippleStrategy()])

// compose funtcions with -->
let composed = overload.forward() --> overload.inverse

// plot results
composed.map{ $0 }
/*: 

Die modulare Implementierung der FFT-Klasse und dem Strategy-Pattern erlaubt das Hinzufügen von Strategien, die von der FFT berücksichtigt werden. Im Rahmen des Prototypen wurden die Algorithmen zu den Mapping- und Noise-Reduction-Strategien aufgrund von gegebenen Ressourcen naiv implementiert. Sie führen zwar zu einem Ergebnis, allerdings sind noch einige naive Annahmen drin, die nicht zum besten Ergebnis führen. Das intensive Auseinandersetzen mit angemessenen Audio-Algorithmen würde zu viel Zeit in Anspruch nehmen, da die theoretischen Hintergründe fundierter betrachtet werden müssen. Es lässt sich wahrscheinlich ein eigenes Guided-Project formulieren, welches einzig und allein diese Thematik behandelt. Aus diesem Grund werden lediglich die naiven Algorithmen von Noise-Reduction und Mapping-Strategien besprochen. Aufgrund der modularen Implementierung der FFT-Klasse können zu einem späteren Zeitpunkt die Implementierungen erweitert und durch bessere Algorithmen ausgetauscht werden.

#### Mapping-Strategien

Wie eingangs (Kapitel »Auditive Wahrnehmung«) bereits beschreiben, ist die Wahrnehmung von Schall für jeden Menschen individuell. Gerade durch das Ausfallen der Tasthaare im Inneren der Hörschnecke können die höheren Frequenzen mit höherem Alter, aber auch in jungen Jahren, wenn das Gehör zu lauten Geräuschen ausgesetzt war, nicht mehr wahrgenommen werden. Um diesem Effekt entgegen zu wirken, wurde im Rahmen dieses Projektes die Überlegung angestellt, dass die fehlenden Frequenzen zu Beginn gemessen werden und dann mittels einer Mapping-Strategie wieder auf den hörbaren Bereich überführt werden. In diesem Abschnitt werden wir genauer auf die Eigenheiten der während des Projektes angewendeten Mapping-Strategien eingehen.

Die Mapping-Strategien werden benötigt, um die Informationen des Signals mit möglichst wenig Verlust auf einem kleineren Frequenzbereich abzubilden. Um dies zu realisieren, wurde die bestehende Aufnahme zuerst mittels linearer Interpolation auf einen höheren Samplingwert gesetzt. Bei diesem Verfahren werden neue Samples zwischen zwei bestehenden Samples mittels *linear Regression* errechnet und hinzugefügt. Nachdem die Aufnahme nun mehr Samples besitzt, in unserem Fall so viele, dass es einen größten gemeinsamen Teiler gibt, kann mittels Downsampling auf die gewünschte Samplerate bzw. in unserem Fall die *FFT Bins* heruntergerechnet werden. Durch das Upsampling und Downsampling soll der Verlust beim Umrechnen minimiert werden, da zu Beginn des Downsamplings mehr Informationen zur Verfügung stehen. Mehr zu diesem Ansatz im nächsten Kapitel.

Zu Beginn des Projektes stand eine naive Lösung im Raum, welche besagte, dass das Audiosignal durch einfaches »Zusammendrücken« in den hörbaren Frequenzbereich überführt werden solle. Diese Strategie ist jedoch aus mehreren Gründen nicht optimal, im Rahmen dieser Ausarbeitung soll jedoch der Hauptgrund als Begründung ausreichen, da dieser in der späteren Lösung umgangen wurde. Beim einfachen Zusammendrücken der Frequenzen kommt es zu einem Informationsverlust. Da die Mappingstrategien innerhalb dieser Ausarbeitung auf den Outputdaten der FFT basieren, ist es nicht möglich mehr »FFT-Bins« für einen bestimmten Frequenzbereich zu erstellen. So muss das Signal von bspw. vorher 1024 Bins auf die noch hörbaren 500 Bins überführt werden. Dieses Beispiel zeigt, dass der Informationsverlust mitunter sehr hoch ausfallen kann. Dies stellt bei kleinen Frequenzverlusten kein Problem dar, führt aber auch nicht zu dem gewünschten Ergebnis.

Um dieses Problem zu umgehen, wurde im Rahmen dieses Projektes zuerst einmal ein Upsampling der bestehenden Audiodatei durchgeführt. Die Up-Samplingrate begründet sich aus dem »größten gemeinsamen Teiler« des Audiosamples und der beabsichtigten Zielsamplegröße. Das Upsampling wurde in diesem Fall mittels linearer Regression vorgenommen. Der folgende Quellcode zeigt die Implementierung des Upsamplings, oder auch Interpolation genannt.

    private func interpolate(values: [Float], upsamplingSize lcm: Int) -> [Float] {
        var result = [Float](count: lcm, repeatedValue: 0.0)
        let stepSize = lcm / values.count

        guard stepSize > 0 else {
            return values
        }

        var f:Float = 1.1

        for i in 0.stride(through: result.count-1, by: stepSize) {
            result[i] = values[i/stepSize]
        }

        for i in 0..<result.count {
            if i%(stepSize) == 0 {
                if i < result.count - stepSize {
                    var higher = i+stepSize
                    if higher == result.count {
                        higher -= 1
                    }
                    f = (result[higher] - result[i]) / Float(stepSize)
                }
            } else {
                if i > 0 { result[i] = result[i-1] + f }
            }
        }
        return result
    }

Nachdem das Audiosignal mittels Interpolation auf die gewünschte Größe hochgerechnet wurde, bestehen mehr Informationen als vorher, auch wenn diese nur durch das Verfahren angenähert wurden. Dies führt zum zweiten Schritt der Mappingstrategie, dem Desampling.

Das Verringern der Samplings kann nun auf zwei Arten erfolgen. Beide Möglichkeiten wurden im Rahmen des Projektes umgesetzt und getestet. Zum einen wäre da die *Maximum-Mappingstrategie*, bei der ein Bereich begutachtet wird und der Maximalwert als Repräsentant gewählt wird. Bei dieser Strategie stellte sich jedoch schnell das Problem heraus, dass die Sprache nicht nur auf den Maximalwerten aufbaut und somit das Audiosignal nicht optimal repräsentiert wird. Der andere Weg, um die Mappingstrategie umzusetzen, ist die *Average-Mappingstrategie*, wie im nachfolgenden Quellcode zu sehen.

    public class AverageMappingStrategy: MappingStrategy {

        public let minIndex: Int
        public let maxIndex: Int

        public init(minIndex: Int, andMaxIndex maxIndex: Int) {
            self.minIndex = minIndex
            self.maxIndex = maxIndex
        }

        public func conflictResolver(x: [Float]) -> Float {
            return sum(x) / Float(x.count)
        }
    }

Die hier dargestellte Implementierung ist nach dem Strategiepattern implementiert. Die Methode *conflictResolver([Float]) -> Float* summiert das übergebene Teilarray und teilt es über die Länge, wodurch der Durchschnittswert dem Outputarray hinzugefügt wird. Die mit dieser einfachen Strategie erzeugten Samples repräsentieren die originale Audiodatei besser als die Ergebnisse der *Max-Mappingstrategie*, weshalb die *Average-Mappingstrategie* im Rahmen dieses Projektes als primäre Mappingstrategie verwendet wurde. Als Proof-of-Concept reichen die Ergebnisse, jedoch sollte für den Produktiveinsatz auf eine bessere Mappingstrategie gewechselt werden. Im Folgenden ist der Plot beider Mappingstrategien angewendet auf den zuvor extrahierten *interleavedSamples* zu sehen. */

// setup
let min = (512 * Int(200)) / (44100 / 2 )
let max = (512 * Int(18000)) / (44100 / 2 )
let sv = Array(interleavedSamples!["left"]![0..<1024])

// plot origin signal for comparison
sv.map{ $0 }

// setup fft with average mapping strategy
let fft1 = FFT(initWithSamples: sv, andStrategy: [AverageMappingStrategy(minIndex: min, andMaxIndex: max)])

// plot avarage mapping results
(fft1.forward() --> fft1.applyStrategy --> fft1.inverse).map{ $0 }

// setup fft with max mapping strategy
let fft2 = FFT(initWithSamples: sv, andStrategy: [MaxMappingStrategy(minIndex: min, andmaxIndex: max)])

// plot max mapping results
(fft2.forward() --> fft2.applyStrategy --> fft2.inverse).map{ $0 }
/*:

Der Vergleich zwischen dem Plot des originalen, mutierten Avarage- und Max-Signales zeigt, dass die Max-Strategy zu viel Informationen wegoptimiert. Rein optisch scheint das Avarage-Signal seine Arbeit angemessener zu vollrichten.

#### Noise-Reduction-Strategien

Damit unnötige Informationen durch die Mappingstrategie nicht höher priorisiert werden, was sowohl durch das Average-Mapping als auch das Max-Mapping passieren könnte, muss eine Art der Noise-Reduction implementiert werden.

Eine der evaluierten Methoden um Nebengeräusche aus einem Audiosignal zu entfernen ist die *Signal-To-Noise-Ratio* (SNR). Bei dem hier überlegten Ansatz wurde die SNR als Threshold verwendet. Dies führt jedoch zu einem Problem, bei dem das Audiosignal ein klingelndes Geräusch aufweist. Dieser Effekt wird auch *ringing artifacts* genannt und entsteht durch einen sogenannten »overshoot« der durch das abrupte Abbrechen des Signals und der weiter schwingenden Membrane des Lautsprechers auftritt. Dieser Effekt macht die Qualität des Audiosignals nicht verständlicher, weshalb noch eine einfachere Lösung für die prototypische Umsetzung gewählt wurde. Nachfolgend noch einmal der Quellcode für diesen ersten Ansatz.

    public class NoiseCancelationStrategy: FilterStrategy {

        public init() {}

        public func apply(x:[Float]) -> [Float] {
            var result:[Float] = [Float]()

            let amdf = averageMagnitudeDifferenceFunction(x)

            for value in x {
                if value >= amdf {
                    result.append(value)
                } else {
                    result.append(0.0)
                }
            }

            return result
        }

        private func averageMagnitudeDifferenceFunction(x: [Float]) -> Float {
            var tmp: Float = 0.0

            for i in 0..<x.count-1 {
                tmp += abs(x[i] - x[i+1])
            }
            return tmp / Float(x.count)
        }
    }

Diese Variante der Noise-Reduction berechnet die Signal-to-Noise-Ratio mittels der *averageMagnitudeDifferendeFunction()*. Wenn nun das originale Signal über dem Threshold liegt, werden die Werte weiter verwendet. Liegt das Signal jedoch unter diesem Schwellwert, so wird der ursprüngliche FFT-Wert genullt. Wie bereits weiter oben beschrieben, führt genau dieses Vorgehen jedoch zu den *ringing-Artifacts*, die nicht zu einer Verbesserung der Audioqualität führt. Aus diesem Grund wird diese Noise-Reduction in diesem Projekt nicht verwendet.

Die zweite Möglichkeit das Rauschen etwas zu unterdrücken ist simpler und auch nicht ganz so vielversprechend wie die Verwendung der SNR. Sie wurde jedoch im Rahmen dieses Projektes implementiert und verwendet, um die Vorteile einer Noise-Reduction nutzen zu können. Im Folgenden ist die Implementierung zu sehen.

    class AverageNoiseMagnitude {
        static let sharedInstance = AverageNoiseMagnitude()

        var anm:Float = 0.0

        private init() {}
    }

    public class NoiseReductionStrategy: FilterStrategy {

        public init() {}

        public func apply(x: [Float]) -> [Float] {
            var result = [Float]()

            let noise = averageNoiseMagnitudes(x)

            for value in x {
                result.append(abs(value - noise.anm))
            }

            return result
        }

        func averageNoiseMagnitudes(x: [Float]) -> AverageNoiseMagnitude {
            let noise = AverageNoiseMagnitude.sharedInstance
            noise.anm = (sum(x) / Float(x.count))
            return noise
        }
    }

Zuerst wird mithilfe des Singleton-Pattern ein Schwellwert ermitteln. Dieser wird mittels des Durchschnittswertes eines Teilarrays berechnet und kann dann vom Ursprungswert subtrahiert werden. Da hierdurch ungewünschte negative Werte entstehen können, wird mit der *abs*-Funktion das Ergebnis in den positiven Zahlenraum überführt.

Im Rahmen dieser Ausarbeitung wurde die Noise-Reduction sehr naiv umgesetzt, weshalb diese in zukünftigen Projekten weiter ausgeführt werden sollte. Zum Demonstrieren der Funktionsweise soll dieser einfache Ansatz jedoch genügen.

### Modifizierte Samples als Audio-Datei abspielen

Nachdem die Mapping- und die Noise-Reduction-Strategien auf das originale Signal angewendet wurden, kann das Signal durch Anwendung der inversen Fouriertransformation wieder in Samples umgerechnet werden. Um die Audiodaten abspielen zu können, können die Samples mittels der Klasse AudioFile wieder in eine Datei geschrieben, also rekonstruiert werden. Hierfür wurde die *saveSamples([Float], String) -> String?*-Funktion implementiert, welche im Folgenden gezeigt wird.

    public func saveSamples(samples: [Float], ToPath path: String) -> String? {
        // convert array to UnsafeMutablePointer
        let samplePointer = UnsafeMutablePointer<Void>(samples)
        
        // create AudioBufferList
        var buffer:AudioBufferList = AudioBufferList()
        buffer.mNumberBuffers = 1
        buffer.mBuffers.mNumberChannels = 1
        buffer.mBuffers.mDataByteSize = UInt32(samples.count)
        buffer.mBuffers.mData = samplePointer
        
        // split path
        let url = NSURL(string: path)!
        let fileName = url.URLByDeletingPathExtension?.URLByAppendingPathExtension("caf").lastPathComponent
        let tmpPath = url.URLByDeletingLastPathComponent
        let clearPath = tmpPath!.path!
        
        // create AudioStreamBasicDescription for PCM
        let desc = self.createBasicPCMDescription()
        
        // safe file and return path
        if let name = fileName {
            return self.saveFileAtPath(clearPath, withName: name, Content: buffer, andDescription: desc).dematerialize()
        } else {
            let defaultPath = NSBundle.mainBundle().resourcePath!
            let junkName = "trash.caf"
            return self.saveFileAtPath(defaultPath, withName: junkName, Content: buffer, andDescription: desc).dematerialize()
        }
    }

In dem vorhergehenden Quellcodebeispiel wird die Speicherung der Audiosamples in Float Repräsentation vorgenommen. Dazu wird zuerst eine neue Instanz von *AudioBufferList* angelegt, welche mit einem Channel konfiguriert wird. Ein Channel besagt, dass es sich hierbei um eine Monoaufnahme handelt. Das Schreiben der Samples ist ein wenig komplizierter, da hier die Unabhängigkeit Swifts von der Programmiersprache C im Weg steht. Damit das Swift-Array durch die C-API verarbeitet werden kann, muss es zuerst in einen *UnsafeMutablePointer* umgewandelt werden.

Nachdem die Daten in eine *AudioBufferList* geschrieben wurden, muss nur der Pfad in eine URL umgewandelt werden. Mittels dieser Informationen und der *AudioStreamBasicPCMDescription* kann die Datei nun einfach im Dateisystem der App angelegt werden. Im Rahmen des Projektes wurde das *linearPCM* Format für die Audiodateien gewählt und in ein **Core Audio File (CAF)** gespeichert.

Des Weiteren wurde eine Wrapperfunktion erstellt, mittels der auch das auf Stereo aufgesplittete Signal in Form eines zweidimensionalen Arrays gespeichert werden kann. Dies soll an dieser Stelle jedoch nicht weiter erläutert werden.

Die gespeicherten Daten können nun vom Standard iOS Audioplayer (*AVAudioPlayer*) gelesen werden. Das Einlesen einer Audiodatei mittels *AVAudioPlayer* ist der folgenden Implementierung zu entnehmen.

    func prepareAudioPlayer(audioPath: String) {
        if let url = NSURL(string: audioPath) {
            do {
                self.player = try AVAudioPlayer(contentsOfURL: url)
            } catch let error as NSError {
                print("error occurred while preparing AudioPlayer \(error)")
                return
            }

            self.player.delegate = self
            self.player.prepareToPlay()
        }
    }

Nachdem die Datei erfolgreich geladen wurde, kann die Wiedergabe mit dem Aufruf *self.player.play()* bzw. *self.player.pause()* abgespielt oder pausiert werden.

## Beispiel anhand eines Anwendungsfalls

In diesem Kapitel soll die FFT-Pipeline anhand einer realen Test-Audiodatei durchlaufen werden. Dabei werden die folgenden Aktivitäten durchgeführt:

* Extrahieren von Samples aus der Audio-Datei
* Manipulation der Samples mithilfe der FFT
* Modifizierte Samples als neue Audiodatei abspeichern

Aus Gründen der Performanz des Playgrounds werden nur die ersten 2048 Samples der Audiodatei betrachtet. Ansonsten würde das Playground zu lange rechnen, um die Ergebnisse anzuzeigen, was ebenfalls das Lesen einschränkt.

Als Erstes werden die Samples aus der Autodatei mithilfe der AudioFile-Klasse extrahiert. Außerdem werden weitere Variablen wie Samplingrate und Länge des FFT Input initialisiert: */

import AVFoundation

// setup
let audioFile = AudioFile()
let filename = "/alex.m4a"

// extract samples and take the first 2048 samples
let data = Array(audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingString(filename))![0..<(1024*2) + (800)])

// proof 2048 samples
data.count

// plot them
data.map{ $0 } 

// define parameters
let samplingRate = 44100
let n = 1024
let length = n / 2

/*:

Im Playground ist die Verwendung des Hörtests nicht möglicht. Deshalb werden die minimale und maximale hörbare Frequenz hartkodiert eingetragen. Allerdings handelt es sich hierbei um den tatsächlichen Frequenzbereichs von einem der beiden Projektpartner. Der Frequenzbereich muss nun noch als Index abgebildet werden, um die entsprechenden Frequenzen identifizieren zu können: */

// define min and max frequencies
let maxFrequency = 13000
let minFrequency = 0

// infer index based on length sampling rate
let maxIndex = (length * Int(maxFrequency)) / (samplingRate / 2 )
let minIndex = (length * Int(minFrequency)) / (samplingRate / 2 )
/*:

Als nächstes werden die Samples mit Nullen aufgefüllt, um ohne Verluste in *n=1024* große Subarrays aufgeteilt zu werden. Auf diese Weise wird die FFT jeweils für 1024 Samples durchgeführt. Die Anzahl der Samples ergibt sich aus dem Informationsgewinn bezüglich der spektralen Darstellung. Um noch genauere Spektren mithilfe der FFT zu bekommen, können auch 2048 Samples gewählt werden. Diese verlangsamen die Berechnung allerdings und bieten für den in diesem Projekt verwendeten Einsatzzweck der Sprachverarbeitung keinen Mehrwert. Des Weiteren werden die Samples mithilfe einer Window-Funktion skaliert. Da die FFT zur Zerlegung von harmonischen Frequenzen gedacht wurde, werden diese Window-Funktionen benötigt, um das Signal für die Transformation zu optimieren. Andernfalls würde die FFT eine höhere »Auflösung« also mehr Input-Samples benötigen, um das selbe Ergebnis zu erzielen.*/

// zero padding with plot
let padded = addZeroPadding(data, whileModulo: n)
padded.map{ $0 }

// window function with plot
let window: [Float] = hamming(padded.count)
window.map{ $0 }

// apply window to samples with plot
let windowedData = window * padded
windowedData.map{ $0 }

// prepare sub arrays for fft
let prepared = prepare(windowedData, steppingBy: n)

/*:

Nachdem alle Vorbereitungen getroffen wurden, folgt die eigentlich FFT. *prepared* ist vom Typ Array<Array<Float>>, da die Samples (Array<Float>) wiederum in 1024 Sample große Unter-Arrays aufgeteilt wurden. Um an jedes Sub-Array zu gelangen, diese in eine FFT zu geben und das Ergebnis wieder zu einem einzigen Array vom Typ Float zu agregieren, wird im Folgenden eine Kombination von *flatMap* und *compose* verwendet: 
*/

let result = prepared.flatMap { samples -> [Float] in
    // setup with composed strategies
    let fft = FFT(initWithSamples: samples, andStrategy: [
        NoiseReductionStrategy(),
        AverageMappingStrategy(minIndex: minIndex, andMaxIndex: maxIndex)]
    )
    
    // perform forward and plot magnitues
    let f = fft.forward()
    magnitudes(f).map{ $0 }
    
    // apply strategies and plot magnitues
    let a = f --> fft.applyStrategy
    magnitudes(a).map{ $0 }
    
    return a --> fft.inverse
}

// undo window function and plot inverse
let unwindowed = result / window
unwindowed.map{ $0 }

/*:

Durch *flatMap* ist *result* vom Typ Array<Float>, also die mit *NoiseReductionStrategy* und *AverageMappingStrategy* modifizierten Samples. Diese müssen nur noch als Audiodatei rekonstruiert und unter einer neuen Datei gespeichert werden: */

// save samples
let savedPath = audioFile.safeSamples(result, ToPath: NSBundle.mainBundle().bundlePath.stringByAppendingString("/blaalex.m4a"))
/*:

## Abschluss

In diesem Kapitel wird die Arbeit abgeschlossen, indem die Ergebnisse zunächst zusammengefasst werden. Danach folgt eine persönliche Einschätzung mit einer kritischen Reflexion der Autoren. Abschließend wird ein Ausblick auf potentiell anschließende Projekte gegeben, die auf den Ergebnissen und Erkenntnissen dieser Arbeit aufbauen können.

### Zusammenfassung

Die Arbeit wurde begonnen, indem theoretische Grundlagen rund um das Thema der auditiven Wahrnehmung und der Physiologie des Ohrs gesammelt wurden, um die Begriffe des Klangmanagement, Klangraumes und der Klangwahrnehmung zu definieren. Des Weiteren wurde die digitale Signalverarbeitung sowohl als Konzept, als auch in seiner technischen Implementierung der Apple vDSP API betrachtet. Die Recherche hat die notwendigen Anstöße gegeben, um an dem Konzept des Klangmanagements unter Berücksichtigung der individuellen Klangwahrnehmung zu arbeiten und die Entwicklung einer iOS App anzustreben, welche mithilfe der [vDSP API](https://developer.apple.com/library/mac/documentation/Performance/Conceptual/vDSP_Programming_Guide/UsingFourierTransforms/UsingFourierTransforms.html#//apple_ref/doc/uid/TP40005147-CH3-SW1), dem [Accelerate Framework](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/AccelerateFWRef/index.html#other) und [AudioKit](http://audiokit.io) die gestellten Anforderungen implementiert. 

Ein Blick in die technische Implementierung der FFT und den Hilfsfunktionen, um das Signal zu bearbeiten, hat gezeigt, dass der Zugriff auf die C API über einen Swift-Wrapper implementiert werden sollte. Um ein schnelles Proof-of-Concept aufzustellen und die Nutzbarkeit der vDSP API zu überprüfen, wurde der Zugriff auf die Funktionen frühzeitig mit einem Prototyp getestet. Die Ergebnisse des Prototyping sind:

* Die Hilfsstrukturen SplitComplexVector<T> und Complex<T>, um die von vDSP verwendete adressbasierte Datenstuktur für komplexe Zahlen zu abstrahieren und die Nutzung von vDSP zu entkoppeln, damit die API der digitalen Signalverarbeitung bei Bedarf ausgetauscht werden kann.
* Die FFT Klasse mit seinen Forward, Inverse und ApplyStrategy-Funktionen. Die Signaturen der Funktionen wurden ebenfalls so gewählt, dass sie zwischen Array<Float> und SplitComplexVector<T> agieren, sodass die Implementierung der Funktionen ggf. auf Basis einer anderen API erfolgen kann.
* Weiteren Hilfsfunktionen, die einen SplitComplexVector<T> entgegennehmen und aus den komplexen Zahlen Informationen extrahieren oder umwandeln (Magnitudes, Polarkoordinaten, usw.). Die Ergebnisse sind ebenfalls vom Typ Float, Array<Float> oder SplitComplexVector<T>, sodass die aufrufende Instanz von vDSP entkoppelt wird.

Das Protoyping wurde mit einer einfachen Sinus-Funktion getestet und in einem Graphen gezeichnet. Die Aufrufe, Erkenntnisse und Graphen finden sich in Kapitel *Manipulation der Samples mithilfe der FFT*. 

Als Nächstes folgte die Implementierung des Hörtests. Der Hörtest soll dabei helfen, den hörbaren Frequenzbereich des Benutzers zu erfahren, um eine individuelle und optimale Anpassung der Klangwahrnehmung zu gewährleisten. Für die Tongenerierung wurde die AudioKit API verwendet. Das Ergebnis des Hörtests sind die minimale und maximale hörbare Frequenz. Diese Informationen gehen als Parameter in die Mapping-Strategie ein.

Die Implementierung der Strategien sind das Herzstück der iOS App. Sie ermöglichen die Manipulation des Signales zwischen FFT-Forward und FFT-Inverse. Die Strategien beschreiben auf welche Art und Weise Samples transformiert werden. Demnach haben die Strategien eine Signatur von *Array<Float> -> Array<Float>*, was die Strategien ebenfalls von der vDSP API entkoppeln. Des Weiteren können Strategien dynamisch zur Laufzeit hinzugefügt und entfernt werden, solange sie dem FilterStrategy-Protocol entsprechen. Das macht die iOS App für Erweiterungen offen, sodass andere Projekte auf diesem Projekt aufbauen können, um die Audio-Algorithmen zur digitalen Signalverarbeitung zu optimieren. Zudem lassen sich mehrere Strategien funktional komponieren, um beispielsweise zuerst eine Noise-Reduction und anschließend einen High-Pass-Filter durchzuführen.

Zuletzt sei noch die Implementierung erwähnt, welche aus einer Audiodatei die Samples in Mono oder Stereo extrahiert und vice versa. Auch hierbei liegt eine C API zugrunde, weshalb ein Swift-Wrapper, die Klasse AudioFile, implementiert wurde. Zudem findet sich in der iOS App ein Audioplayer, um die an die Klangwahrnehmung des Benutzers angepassten Samples als Audio-Datei abzuspielen. All diese Schritte bilden den FFT-Stack, wie er in Kapitel *Beispiel anhand eines Anwendungsfalls* zu sehen ist. Das Design wurde so gewählt, dass die Verarbeitung möglichst performant ist, um die Audio-Datei unmittelbar nach dem Hörtest abzuspielen und keine zusätzlichen Wartezeiten zu dulden.

### Persönliche Einschätzung und kritische Reflexion

Die wohl wichtigste Erkenntniss der Arbeit ist, dass die theoretischen Grundlagen nicht trivial sind und tiefe mathematische und physikalische Wurzeln haben, die durch jahrelange Forschung in diesem Gebiet geprägt wurden. Ein oberflächliches Einarbeiten reicht nicht aus, um an der digitalen Signalverarbeitung mitwirken zu können. Des Weiteren ist die Domäne geprägt von vielen Fachbegriffen, um bestimmte Zustände und Objekte präzise zu beschreiben. Gerade die Fourier-Transformation bedarf an Einarbeitungszeit, um dessen Bedeutung, Relevanz und Umgang zu verstehen.

Zudem existieren sehr viele unterschiedliche Ansätze, Konzepte und damit auch Implementierungen von Audio-Algorithmen, die sehr komplex sind und in den meisten Fällen stark an Bibliotheken von Programmiersprachen und Frameworks geknüpft sind, weil dort gerade auf Low-Level Ebene viele Optimierungen durchgeführt werden, um eine durchaus notwendige Performanz zu gewährleisten. Das intensive Beschäftigen mit solchen Algorithmen würde ein eigenes Guided-Projekt, oder sogar ein Guided-Projekt je Algorithmen-Familie mit sich bringen, da die Thematik und vor allem dessen theoretischer Hintergrund komplex und speziell ist. Deshalb wurde der Kern der Arbeit auf die Entwicklung eines Frameworks zum Klangmanagment, der Anpassung von Klangräumen an die individuelle Wahrnehmung des Menschen, ausgerichtet. Das Framework umfasst

* einen individuellen Hörtest,
* eine Swift Abstraktion für die Benutzung der C-artigen vDSP API inklusive Hilfsfunktionen und einer funktionalen Zugriffsart,
* das dynamische Austauschen und Hinzufügen von Manipulations-Strategien zur Laufzeit und
* das Einlesen, Extrahieren und Abspeichern von Audio-Dateien vor und nach der Anpassung der Klangräumen.

Das Auseinandersetzen mit der vDSP API war herausfordernd, da der Umgang mit einer adress- und pointerbasierten API in einer High-Level Programmiersprache mühselig und side-effect behaftet ist. Das macht den Quellcode nicht nur unschön, sondern auch unleserlich und inkohärent. Vor allem wenn  bedacht wird, dass Swift aus der Intention heraus entwickelt wurde, um den alten C Balast abzuwerfen und eine moderne Programmiersprache zu sein.

Die Implementierung des Hörtest ist zielführend und zufriendenstellend verlaufen, auch wenn sie simpel gehalten wurde. Allerdings ist sie so gewählt, dass man ohne weiteres die Tongenerierung von 0 bis 22000 Hz dediziert für beide Ohren erzeugen kann. Dadurch kann man die Frequenzen für beide Ohren getrennt (Stereo) aufnehmen und die Klangwahrnehmung potenziell noch individueller, nämlich für beide Ohren getrennt, durchführen. Des Weiteren ist die Abhängigkeit zur Amplitude bei der Tongenerierung bereits implementiert, allerdings noch nicht in aktiver Verwendung. In einer weiteren Iteration kann die Amplitude beim Mapping der Frequenzen berücksichtigt werden. Allerdings ist es noch fraglich, inwiefern dieses Feature das Ergebnis optimieren würde.

Die Implementierung der Audio-Algorithmen für die Strategien ist hingegen semi-zufriendenstellend verlaufen. Das Team wollte schnell Ergebnisse erzielen, um die prototypische Implementierung des FFT-Stacks nicht nur an der Sinus-Funktion, sondern auch an realen Audio-Dateien zu testen. Aus diesem Grund wurden die Algorithmen zwar konzeptionell sinnvoll geplant, jedoch simpel und unter einfachen Annahmen implementiert. Gegen Ende des Projektes blieb nicht genügend Zeit, um sich intensiv mit geeigneteren Algorithmen auseinanderzusetzen und die bestehenden Algorithmen zu optimieren. Schließlich sollte das Projekt zu einem geeigneten Zeitpunkt abgeschlossen werden. Wie bereits erwähnt, tritt hierbei auch die hohe Komplexität der Algorithmen in Kraft, weshalb die Zeit und der Aufwand diesbezüglich reduziert wurden. Unglücklicherweise hat das starke Auswirkungen auf das hörbare Ergebnis des Klangmanagments. Obwohl eine, wenn auch naive Noise-Reduction und eine theoretisch durchdachte Frequenz-Mapping-Strategie miteinander komponiert wurden, sind die Stimmen in der Audio-Datei mechanisch und weniger verständlich, als sie nach den Annahmen des Teams sein sollten. Das liegt unter anderem daran, dass die Noise-Reduction das Grundrauschen mithilfe eines Faktors über alle Zeiteinheiten hinweg reduziert. Somit werden unter Umständen auch Informationen wegoptimiert, die eigentlich relevant sind. Hierbei wäre es sinnvoller, die gesamte Darstellung zu analysieren und mithilfe geeigneter und anerkannter Noise-Reduction Verfahren das Grundrauschen pro Block (beispielsweise 128 Samples) dediziert zu reduzieren. Außerdem wäre es denkbar mithilfe eines *Silent-Detection*-Algorithmus das Rauschen besser zu bestimmen, so dass nicht mehr von einer allgemeinen Signal-to-Noise-Ratio ausgegangen werden muss. Damit sollte die Destruktionsrate geringer sein, was zu einem besseren Ergebnis führen könnte. Des Weiteren können die beiden Frequenz-Mapping-Strategien eleganter implementiert werden, beispielsweise mit einer besseren Aproximation der Werte. Das Mappen zwischen mehreren Samples könnte zusätzlich unter Berücksichtigung der Magnitudes erfolgen. Dabei könnte man sich auch die Magnitudes vor und nach dem Interpolationsblock anschauen und unter Zunahme der Frequenz berechnen, was für eine Art von Signal die aktuellen Samples darstellen. Losgelöst von den Mapping Strategien kann auch die genaue Kategorie, ob laute Stimmen, leise Stimmen, eine Pause oder Mitten in einem Satz, zur Verbesserung der Audiospur dienen. Beispielsweise können Stimmen aus dem Hintergrund an die Lautstärke des im Vordergrund befindlichen Sprechers angepasst werden. Dies wurde jedoch im Rahmen dieses Projektes nur theoretisch bearbeitet, da die Umsetzung, wie weiter oben beschrieben nicht in der gewählten Projektart möglich war.

Nichts­des­to­trotz bildet die iOS App den Workflow bzw. den FFT-Stack dahingehend ab, dass ein Klangmanagement mit der individuellen Anpassung von Klangräumen an die menschliche Wahrnehmung stattfindet. Der Hörtest liefert ein Frequenzprofil, welches in die digitale Signalverarbeitung eingeht. Bei einer geeigneten Parallelisierung der FFT könnten die 1024 Samples große Blöcke auf mehrere Kerne aufgeteilt und anschließend wieder zu einem gesamten Block zusammengesetzt werden. Mit dem *Grand Central Dispatch (GCD)* von Apple und der hohen Performanz aktueller iOS Geräte (iPad Pro, iPhone 6s und 6s+) könnte die Implementierung die Verarbeitung in Echteit annähern. Außerdem wurde darauf geachtet, dass die Implementierung der FFT-Klasse die Objektorientierung mit funktionalen Aspekten kombiniert, um zum Einen flexibel eingesetzt zu werden und zum Anderen den FFT-Kontext in sich geschlossen zu tragen. Zudem lässt sich dadurch eine Parallelisierung relativ unkompliziert einführen, da die Funktionen *forward*, *applyStrategy* und *inverse* pure Funktionen sind und keine Abhängigkeiten haben. Die einzige Ausnahme ist das Setup des FFT-Kontextes, welches ohnehin in das FFT-Objekt eingeschlossen ist (Objektorientierung).

Im Großen und Ganzen ist die Bearbeitung der Aufgabenstellung gelungen. Die simple Behandlung der Algorithmen ist zwar unbefriedigend, allerdings liefert die modulare Implementierung des Frameworks zum Klangmanagement ein hohes Maß an Entwicklungspotenzial. Das Konzept des Klangmanagement zur individuellen Anpassung der Klangräume an die menschliche Klangwahrnehmung hat durchaus seine Berechtigung und findet beispielsweise seine Relevanz in Hardwareprodukten, wie es beispielsweise bei [AMP](https://www.ampaudio.com) zu sehen ist.

### Ausblick

Die Implementierung des Strategy-Pattern für Filter-Strategien lässt zu, dass neue Audio-Algorithmen dem bestehenden FFT-Stack hinzugefügt werden können, sofern sie dem FilterStrategy-Protocol entsprechen. Demnach kann das Projekt als Basis verwendet werden, um sich intensiv und fundiert mit anerkannten Best-Practise Algorithmen für digitale Signalverarbeitung auseinander zu setzen und diese in die Anwendung zu implementieren bzw. die bestehenden Algorithmen zu optimieren. Die Implementierungen können anschließend instanziert, an die FFT-Klasse übergeben und mit anderen Strategien komponiert werden. Hierbei ist es interessant zu untersuchen, ob die Algorithmen zu einem besseren Ergebnis führen.

Auch die Tatsache, das während des Projektes an Mehrspur-Audio gedacht wurde, vor allem in der Implementierung der AudioFile-Klasse, ermöglicht es die Algorithem auch für mehrspuriges Audio einfach anzupassen. So kann mit relativ wenig Aufwand auf »mehrdimensionales« Audio wie 5.1 Surround angepasst werden, da auch hier ein Interleaved Signal verwendet wird. Ein Beispiel für die Anpassung von Algorithmen auf Mehrspur Audio könnte die Anpassung des Schalls auf die Raumbelegung sein. So könnten dynamisch Lautstärken der einzelnen Lautsprecher angepasst werden.

Neben den Algorithmen lässt sich der Hörtest erweitern. Hierbei kann der Frequenztest diferenziert für beide Ohren erfolgen, wie zum Beispiel beim [Mimi Hörtest](https://itunes.apple.com/de/app/mimi-hortest/id932496645?mt=8). Außerdem kann die Amplitude in der weiteren Verarbeitung mit Berücksichtigt werden. Die Daten fallen bereits jetzt schon an, werden allerdings nicht weiter verwendet. Auch hier wäre es interessant zu untersuchen, inwiefern das Ergebnis optimiert werden könnte.
*/
