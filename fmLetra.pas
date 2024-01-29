unit fmLetra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, DBCtrls, DB, ADODB,
  bsSkinCtrls, bsdbctrls, Vcl.Mask, bsSkinBoxCtrls, BusinessSkinForm,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, ShellApi,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfLetra = class(TForm)
    sPanel2: TbsSkinPanel;
    reLetra: TbsSkinRichEdit;
    sSplitter1: TbsSkinSplitter;
    qrBUSCA: TFDQuery;
    dsBUSCA: TDataSource;
    dbLista: TbsSkinDBLookupListBox;
    GridPanel1: TGridPanel;
    txtLocaliz: TbsSkinEdit;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinScrollBar8: TbsSkinScrollBar;
    GridPanel2: TGridPanel;
    tbSlideM: TbsSkinButton;
    tbSlideSM: TbsSkinButton;
    btErro: TbsSkinButton;
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    Carregando: TbsSkinDBText;
    qrLETRA: TFDQuery;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinDBLookupListBox1: TbsSkinDBLookupListBox;
    qrALBUNS: TFDQuery;
    dsALBUNS: TDataSource;
    procedure FormActivate(Sender: TObject);
    procedure tbSlideMClick(Sender: TObject);
    procedure txtLocalizChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure abreLetra();
    procedure dbListaClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btErroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    mMusica_C, mMusica_I, mMusica_A: string;
    id_mus: Integer;
    u_id: integer;
  end;

var
  fLetra: TfLetra;

implementation

uses
  fmMenu, fmIniciando;

{$R *.dfm}

procedure TfLetra.FormActivate(Sender: TObject);
begin
  reLetra.Lines.Clear;
  u_id := 0;

  qrBUSCA.Close;
  qrBUSCA.Open;

  dbLista.KeyValue := id_mus;

  abreLetra();
  txtLocaliz.SetFocus;
end;

procedure TfLetra.tbSlideMClick(Sender: TObject);
begin
  fmIndex.abreLetraMusica('BD','',qrBUSCA.FieldByName('ID').AsInteger,(TComponent(Sender).Tag) = 0);
end;

procedure TfLetra.txtLocalizChange(Sender: TObject);
begin
  fmIndex.Localizar(txtLocaliz.text, reLetra, True);
end;

procedure TfLetra.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  txtLocaliz.Text := '';
end;

procedure TfLetra.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  fmIndex.FormKeyUp(Sender, Key, Shift);
end;

procedure TfLetra.abreLetra;
var
  letra: string;
  letra_t: TStringList;
begin
  if (u_id = qrBusca.fieldbyname('ID').AsInteger) then Exit;
  u_id := qrBusca.fieldbyname('ID').AsInteger;

  qrALBUNS.Close;
  qrALBUNS.ParamByName('MUSICA').Value := qrBusca.fieldbyname('ID').AsInteger;
  qrALBUNS.Open;

  reLetra.Lines.Clear;
  letra_t := TStringList.Create;
  letra_t.Clear;

  qrLETRA.Close;
  qrLETRA.ParamByName('MUSICA').Value := qrBusca.fieldbyname('ID').AsInteger;
  qrLETRA.Open;
  while not qrLETRA.Eof do
  begin
    letra := '';
    if (qrLETRA.fieldbyname('LETRA_AUX').AsString <> '') then
      letra := letra+'['+qrLETRA.fieldbyname('LETRA_AUX').AsString+'] ';

    letra := letra+qrLETRA.fieldbyname('LETRA').AsString;
    letra := StringReplace(letra, #13#10, ' ', [rfIgnoreCase, rfReplaceAll]);
    letra_t.Add(letra);
    qrLETRA.Next;
  end;

  if (reLetra.Lines <> letra_t) then
    reLetra.Lines := letra_t;

  fmIndex.formataTexto(reLetra);
  txtLocalizChange(nil);
end;

procedure TfLetra.btErroClick(Sender: TObject);
var
  url: string;
begin
  url := fmIndex.param.Strings.Values['form'+fIniciando.LANG];
  if (url = '') then
    Application.MessageBox(PChar('N�o foi poss�vel acessar o formul�rio de contato! Acesse o formul�rio em https://louovorja.com.br!'), fmIndex.TITULO, mb_ok + mb_iconinformation)
  else
    ShellExecute(handle, nil, PChar(url), nil, nil, SW_MAXIMIZE);
end;

procedure TfLetra.dbListaClick(Sender: TObject);
begin
  abreLetra();
end;

end.

