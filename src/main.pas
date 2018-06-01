unit main;

interface

uses
  Winapi.Windows,System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DosCommand,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox;

type
  Tfmmain = class(TForm)
    Memo1: TMemo;
    DosCommand1: TDosCommand;
    ToolBar1: TToolBar;
    ComboBox1: TComboBox;
    StyleBook1: TStyleBook;
    Label1: TLabel;
    procedure ProcessDosCommand(Sender: TObject);
    procedure DosCommand1Terminated(Sender: TObject);
    procedure DosCommand1NewLine(ASender: TObject; const ANewLine: string;
      AOutputType: TOutputType);
    procedure FormShow(Sender: TObject);
    procedure DosCommand1ExecuteError(ASender: TObject; AE: Exception;
      var AHandled: Boolean);
    procedure DosCommand1TerminateProcess(ASender: TObject;
      var ACanTerminate: Boolean);
    procedure ComboBox1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmmain: Tfmmain;

implementation

{$R *.fmx}

procedure Tfmmain.ProcessDosCommand(Sender: TObject);
var
toProcess,fitem:string;// Set what you want to process
begin
 if DosCommand1.IsRunning then
  DosCommand1.Stop; //if running stop
  DosCommand1.InputtoOutput := False;
  DosCommand1.MaxTimeAfterBeginning := 1; //must action this else the process
  //does not finish
  DosCommand1.MaxTimeAfterLastOutput := 10;  //this ensures thet the multiple
  // threads are completed and auto stops the commmand
  DosCommand1.CommandLine := GetEnvironmentVariable('COMSPEC');//opens the CMD.exe
  DosCommand1.Execute;
  // Starts the process and opens the cmd.exe to point to the
  // Application.exe folder
  if Combobox1.Itemindex >= 0  then
 fitem:= Combobox1.selected.text;
  ToProcess := getenvironmentVariable('WINDIR')+'\SYSTEM32\'+fitem;//fitem is the exe to process
  DosCommand1.SendLine(ToProcess, true); //
  DosCommand1.SendLine('', true); // equivalent to press enter key
 end;

procedure Tfmmain.ComboBox1Change(Sender: TObject);
begin
memo1.Lines.Clear;
//add this in for those processes that take a long time
 if ((combobox1.ItemIndex = 1) or (combobox1.ItemIndex = 4)) then
 memo1.Lines.Add( 'Please Be Patient this process takes a while to process'+'...........') ;
 ProcessDOSCommand(self);
end;

procedure Tfmmain.DosCommand1ExecuteError(ASender: TObject; AE: Exception;
  var AHandled: Boolean);
begin
if AHandled then
  Showmessage(AE.ToString);
end;

procedure Tfmmain.DosCommand1NewLine(ASender: TObject; const ANewLine: string;
  AOutputType: TOutputType);
begin
AOutputType:=otEntireLine;
memo1.Lines.Add(ANewline);  //Outputs the lines of the CMD.EXE
end;

procedure Tfmmain.DosCommand1Terminated(Sender: TObject);
begin
//use this area todo something when the multithreaded
//process has completed/terminated
memo1.Lines.Add('Completed The Process...........');
end;

procedure Tfmmain.DosCommand1TerminateProcess(ASender: TObject;
  var ACanTerminate: Boolean);
begin
   ACanTerminate:= true;   (*called when Dos-Process has to be terminated
  by asking if thread can terminate process *)
  end;

procedure Tfmmain.FormShow(Sender: TObject);
begin
  combobox1.ItemIndex:= 1;
end;

end.
