// =========================================================================
//  File: RobotClient.ck
//  Takes midi input from an IAC bus and sends OSC to the robot server
//  by Bruce Lott & Ness Morris
//  CalArts Music Technology: Interaction, Intelligence & Design
//  January 2014
// =========================================================================

MidiIn min;
MidiMsg msg;
OscOut oout;

int status, chan, noteNum, vel;

<<<"","">>>;
// choose which IAC bus to use
if(me.args()){
    if(min.open(Std.atoi(me.arg(0)))){ 
        // open argument as IAC bus
        <<<"Successfully connected to",min.name()+"!">>>;
    }
}
else if(min.open("IAC Driver IAC Bus 1")){ 
    // default name of a new IAC bus
    <<<"Successfully connected to", min.name() +"!">>>;
}
else <<<"Failed to open IAC Bus","">>>;
<<<"","">>>;

// connect to robot server
("chuckServer.local",50000) => oout.dest;


// spork main loop
spork ~ midiLoop();

// confirm setup completion
// good luck time
10::second => now; 
<<<"If you didn't get any errors, you should be good to go!","">>>;

while(samp=>now);

[45,47,48,50,52,53,54,55,
57,59,60,62,64,65,66,67,
69,71,72,74,76,77,78,79,
81,83,84,86,88,89,90,91,
93,95,96,97] @=> int marimbaScale[];

// main loop
fun void midiLoop(){
    while(min=>now){
        while(min.recv(msg)){
            (msg.data1 & 0xF0)>>4 => status; // midi status byte
            (msg.data1 & 0x0F) => chan;      // midi channel
            if(status==9){ // note on
                msg.data2 => noteNum;
                msg.data3 => vel;
                if(chan==0){ // maha devi
                    if(noteNum > 59 & noteNum < 74){
                        oout.start("/devibot");
                        oscOut(noteNum, vel);
                        <<< "/devibot", noteNum - 60, vel >>>;
                    }
                }
                if(chan==1){ // gana pati
                    if(noteNum > 59 & noteNum < 81){
                        oout.start("/ganapati");
                        oscOut(noteNum, vel);
                        <<< "/ganapati", noteNum - 60, vel >>>;
                    }
                }
                if(chan==2){ // breakbot
                    if(noteNum > 59 & noteNum < 86){
                        oout.start("/drumBot");
                        oscOut(noteNum, vel);
                        <<< "/drumBot", noteNum - 60, vel >>>;
                    }
                }
                if(chan==3){ // clappers
                    if(noteNum>59 & noteNum<81){
                        oout.start("/clappers");
                        oscOut(noteNum, vel);
                        <<< "/clappers", noteNum - 60, vel >>>;
                    }
                }
                if(chan==4){ // jackbox percussion
                    if(noteNum>59 & noteNum<100){
                        oout.start("/jackperc");
                        oscOut(noteNum, vel);
                        <<< "/jackperc", noteNum - 60, vel >>>;
                    }
                }
                if(chan==5){ // jackbox bass
                    if(noteNum>59-8 & noteNum<84-8){
                        oout.start("/jackbass");
                        oscOut(noteNum + 8, vel);
                        <<< "/jackbass", noteNum + 8 - 60 >>>;
                    }
                }
                if(chan==6){ // jackbox guitar
                    if(noteNum>59-8 & noteNum<94-8){
                        oout.start("/jackgtr");
                        oscOut(noteNum + 8, vel);
                        <<< "/jackgtr", noteNum + 8 - 60, vel >>>;
                    }
                }
                if(chan==7){ // MDarimBot
                    oout.start("/marimba");
                    serialOscOut(noteNum, vel);
                    <<< "/marimba", noteNum, vel >>>;
                }
                if(chan==8){ // Trimpbeat
                    oout.start("/trimpbeat");
                    serialOscOut(noteNum, vel);
                    <<< "/trimpbeat", noteNum, vel >>>;
                }
                if(chan==9){ // Trimpspin
                    oout.start("/trimpspin");
                    serialOscOut(noteNum, vel);
                    <<< "/trimpspin", noteNum, vel >>>;
                }
                if(chan==10){ // StringThing 
                    oout.start("/stringthing");
                    serialOscOut(noteNum, vel);
                    <<< "/stringthing", noteNum, vel >>>;
                }
                if(chan==12){ // RattleTron
                    oout.start("/rattletron");
                    serialOscOut(noteNum, vel);
                    <<< "/rattletron", noteNum, vel >>>;
                }
                if(chan==13){ // WindBot
                    if(noteNum > 59){
                        noteNum - 60 => noteNum;
                    }
                    oout.start("/windbot");
                    serialOscOut(noteNum, vel);
                    <<< "/windbot", noteNum, vel >>>;
                }
                if(chan==11){ // Snapperbots
                    if(noteNum > 59){
                        noteNum - 60 => noteNum;
                    }
                    if (noteNum < 4){
                    oout.start("/snapperbot1");
                    serialOscOut(noteNum, vel);
                    <<< "/snapperbot1", noteNum, vel >>>;
                    }
                    else if (noteNum < 8){
                    oout.start("/snapperbot2");
                    serialOscOut(noteNum, vel);
                    <<< "/snapperbot2", noteNum, vel >>>;
                    }
                    else if (noteNum < 12){
                    oout.start("/snapperbot3");
                    serialOscOut(noteNum, vel);
                    <<< "/snapperbot3", noteNum, vel >>>;
                    }
                    else if (noteNum < 16){
                    oout.start("/snapperbot4");
                    serialOscOut(noteNum, vel);
                    <<< "/snapperbot4", noteNum, vel >>>;
                    }
                    else if (noteNum < 20){
                    oout.start("/snapperbot5");
                    serialOscOut(noteNum, vel);
                    <<< "/snapperbot5", noteNum, vel >>>;
                    }
                    else if (noteNum < 24){
                    oout.start("/snapperbot6");
                    serialOscOut(noteNum, vel);
                    <<< "/snapperbot6", noteNum, vel >>>;
                    }
                }
            }
            if(status==8){ // note off
                if(chan==5){ // jackbox bass
                    if(noteNum>59-8 & noteNum<84-8){
                        oout.start("/jackbass");
                        oscOut(noteNum + 8, 0);
                        // xmit.startMsg("/jackbass,ii");
                    }
                }
                if(chan==6){ // jackbox guitar
                    if(noteNum>59-8 & noteNum<94-8){
                        oout.start("/jackgtr");
                        oscOut(noteNum + 8, 0);
                    }
                }
                if(chan==9){ //Trimpspin
                    oout.start("/trimpspin");
                    oscOut(noteNum, 0);
                }
            }
        }
    }
}

fun void serialOscOut(int newNoteNum, int newVel){
    oout.add(newNoteNum);
    oout.add(newVel);
    oout.send();
}

fun void oscOut(int newNoteNum, int newVel){
    oout.add(newNoteNum - 60);
    oout.add(newVel);
    oout.send();
}
