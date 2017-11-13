program dllWithStringClient;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;

type
  TMyProc = function (const name: Pchar; const sizeName: Cardinal;
                  out response: PChar; out sizeResponse: Cardinal): boolean; stdcall;

var
  vName: string;
  vResponse: string;
  name: Pchar;
  sizeName: Cardinal;
  response: PChar;
  sizeResponse: Cardinal;
  handle: THandle;
  myProc: TMyProc;
begin
  try
    { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
    writeln('input your name :');
    readln(vName);
    name := PChar(vName);
    sizeName := sizeof(name);
    handle := loadlibrary('dllWithString.dll');
    if handle <> 0 then
    begin
      try
        @myProc := GetProcAddress(handle, 'SayHello');
        if @myProc <> nil then
        begin
          myProc(name, sizeName, response, sizeResponse);
          vResponse := response;
          writeln(vResponse);
          readln;
        end
        else
        begin
          writeln('function SayHello not found in dll');
          readln;
        end;
      finally
        freelibrary(handle);
      end;
    end
    else
    begin
      writeln('dll not found.');
      readln;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
