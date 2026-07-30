xmlport 91805 "3PL 308-Export Purch Period"
{
    Caption = 'Purchase - Export Purchase Documents Period SAP - CSV (Logisteed)';
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    Permissions = tabledata "Purch. Comment Line" = rim;
    schema
    {
        textelement(Root)
        {
            tableelement(Header; Integer)
            {
                SourceTableView = sorting(Number) where(Number = const(1));
                XmlName = 'Header';

                trigger OnAfterGetRecord()
                begin
                    currXMLport.Filename(Text001);
                    if not CreateBuffer() then
                        currXMLport.Quit();
                    currXMLport.Break();
                end;
            }
            tableelement(InvoiceLines; Integer)
            {
                XmlName = 'InvoiceLines';
                SourceTableView = sorting(Number) where(Number = filter(0 ..));
                textelement(InvoiceColumn01) { }
                textelement(InvoiceColumn02) { }
                textelement(InvoiceColumn03) { }
                textelement(InvoiceColumn04) { }
                textelement(InvoiceColumn05) { }
                textelement(InvoiceColumn06) { }
                textelement(InvoiceColumn07) { }
                textelement(InvoiceColumn08) { }
                textelement(InvoiceColumn09) { }
                textelement(InvoiceColumn10) { }
                textelement(InvoiceColumn11) { }
                textelement(InvoiceColumn12) { }
                textelement(InvoiceColumn13) { }
                textelement(InvoiceColumn14) { }
                textelement(InvoiceColumn15) { }
                textelement(InvoiceColumn16) { }
                textelement(InvoiceColumn17) { }
                textelement(InvoiceColumn18) { }
                textelement(InvoiceColumn19) { }
                textelement(InvoiceColumn20) { }
                textelement(InvoiceColumn21) { }
                textelement(InvoiceColumn22) { }
                textelement(InvoiceColumn23) { }
                textelement(InvoiceColumn24) { }
                textelement(InvoiceColumn25) { }
                textelement(InvoiceColumn26) { }
                textelement(InvoiceColumn27) { }
                textelement(InvoiceColumn28) { }
                textelement(InvoiceColumn29) { }
                textelement(InvoiceColumn30) { }
                textelement(InvoiceColumn31) { }
                textelement(InvoiceColumn32) { }
                textelement(InvoiceColumn33) { }
                textelement(InvoiceColumn34) { }
                textelement(InvoiceColumn35) { }
                textelement(InvoiceColumn36) { }
                textelement(InvoiceColumn37) { }
                textelement(InvoiceColumn38) { }
                textelement(InvoiceColumn39) { }
                textelement(InvoiceColumn40) { }

                trigger OnAfterGetRecord()
                begin
                    ClearColumnsInvoice();

                    if InvoiceLines.Number = 0 then begin
                        if not InvoiceLineBuffer.FindSet() then
                            currXMLport.Break();
                    end else begin
                        if InvoiceLineBuffer.Next() = 0 then
                            currXMLport.Break();
                    end;

                    if InvoiceLineBuffer."Line No." = 0 then begin
                        Clear(Counter);
                        FillCsvDataHeaderInvoice(Counter);
                    end else begin
                        Counter += 1;
                        // if not ((InvoiceLineBuffer."No." = '112TK') and (InvoiceLineBuffer."Line Amount" = 0)) then
                        FillCsvDataLineInvoice(Counter);
                    end;
                end;

                trigger OnPreXmlItem()
                begin
                    Clear(Counter);
                end;
            }
            tableelement(CrMemoLines; Integer)
            {
                XmlName = 'CrMemoLines';
                SourceTableView = sorting(Number) where(Number = filter(0 ..));
                textelement(CrMemoColumn01) { }
                textelement(CrMemoColumn02) { }
                textelement(CrMemoColumn03) { }
                textelement(CrMemoColumn04) { }
                textelement(CrMemoColumn05) { }
                textelement(CrMemoColumn06) { }
                textelement(CrMemoColumn07) { }
                textelement(CrMemoColumn08) { }
                textelement(CrMemoColumn09) { }
                textelement(CrMemoColumn10) { }
                textelement(CrMemoColumn11) { }
                textelement(CrMemoColumn12) { }
                textelement(CrMemoColumn13) { }
                textelement(CrMemoColumn14) { }
                textelement(CrMemoColumn15) { }
                textelement(CrMemoColumn16) { }
                textelement(CrMemoColumn17) { }
                textelement(CrMemoColumn18) { }
                textelement(CrMemoColumn19) { }
                textelement(CrMemoColumn20) { }
                textelement(CrMemoColumn21) { }
                textelement(CrMemoColumn22) { }
                textelement(CrMemoColumn23) { }
                textelement(CrMemoColumn24) { }
                textelement(CrMemoColumn25) { }
                textelement(CrMemoColumn26) { }
                textelement(CrMemoColumn27) { }
                textelement(CrMemoColumn28) { }
                textelement(CrMemoColumn29) { }
                textelement(CrMemoColumn30) { }
                textelement(CrMemoColumn31) { }
                textelement(CrMemoColumn32) { }
                textelement(CrMemoColumn33) { }
                textelement(CrMemoColumn34) { }
                textelement(CrMemoColumn35) { }
                textelement(CrMemoColumn36) { }
                textelement(CrMemoColumn37) { }
                textelement(CrMemoColumn38) { }
                textelement(CrMemoColumn39) { }
                textelement(CrMemoColumn40) { }

                trigger OnAfterGetRecord()
                begin
                    ClearColumnsCrMemo();

                    if CrMemoLines.Number = 0 then begin
                        if not CrMemoLineBuffer.FindSet() then
                            currXMLport.Break();
                    end else begin
                        if CrMemoLineBuffer.Next() = 0 then
                            currXMLport.Break();
                    end;

                    if CrMemoLineBuffer."Line No." = 0 then begin
                        Clear(Counter);
                        FillCsvDataHeaderCrMemo(Counter);
                    end else begin
                        Counter += 1;
                        // if not ((CrMemoLineBuffer."No." = '112TK') and (CrMemoLineBuffer."Line Amount" = 0)) then
                        FillCsvDataLineCrMemo(Counter);
                    end;
                end;

                trigger OnPreXmlItem()
                begin
                    Clear(Counter);
                end;
            }
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(SettingsGroup)
                {
                    ShowCaption = false;
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                    }
                    field(UntilDate; UntilDate)
                    {
                        Caption = 'Until Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }
    trigger OnPreXmlPort()
    begin
        InvoiceLineBuffer.Reset();
        InvoiceLineBuffer.DeleteAll(false);
        CrMemoLineBuffer.Reset();
        CrMemoLineBuffer.DeleteAll(false);
    end;

    var
        InvoiceLineBuffer: Record "Purch. Inv. Line" temporary;
        CrMemoLineBuffer: Record "Purch. Cr. Memo Line" temporary;
        TypeHelper: Codeunit "Type Helper";
        FromDate: Date;
        UntilDate: Date;
        Counter: Integer;
        Text001: Label 'Purchase Documents.csv';
        FirstLogisticsDocumentNo, VendorInvoiceNo : Code[20];

    local procedure FormatDec(ValueIn: Decimal): Text
    var
        Language: Codeunit Language;
    begin
        exit(TypeHelper.FormatDecimal(ValueIn, 'F2', Language.GetCultureName(GlobalLanguage)));
    end;


    local procedure CreateBuffer() BufferCreated: Boolean
    var
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCommentDocumentType: Enum "Purchase Comment Document Type";
    begin
        if FromDate = 0D then //werkdatum - 3maanden
            FromDate := CalcDate('-3M', WorkDate());

        if UntilDate = 0D then
            UntilDate := DMY2Date(1, 1, 9999);

        PurchInvoiceHeader.Reset();
        PurchInvoiceHeader.SetCurrentKey("Posting Date");
        PurchInvoiceHeader.SetRange("Posting Date", FromDate, UntilDate);
        if PurchInvoiceHeader.FindSet() then begin
            repeat
                if ExportNeeded(PurchCommentDocumentType::"Posted Invoice", PurchInvoiceHeader."No.") then begin
                    if CreateBufferInvoice(PurchInvoiceHeader."No.") then
                        InsertModifyExportMarker(PurchCommentDocumentType::"Posted Invoice", PurchInvoiceHeader."No.");
                end;
            until PurchInvoiceHeader.Next() = 0;
        end;

        PurchCrMemoHeader.Reset();
        PurchCrMemoHeader.SetCurrentKey("Posting Date");
        PurchCrMemoHeader.SetRange("Posting Date", FromDate, UntilDate);
        if PurchCrMemoHeader.FindSet() then begin
            repeat
                if ExportNeeded(PurchCommentDocumentType::"Posted Credit Memo", PurchCrMemoHeader."No.") then begin
                    if CreateBufferCrMemo(PurchCrMemoHeader."No.") then
                        InsertModifyExportMarker(PurchCommentDocumentType::"Posted Credit Memo", PurchCrMemoHeader."No.");
                end;
            until PurchCrMemoHeader.Next() = 0;
        end;

        InvoiceLineBuffer.Reset();
        CrMemoLineBuffer.Reset();
        exit(not (InvoiceLineBuffer.IsEmpty and CrMemoLineBuffer.IsEmpty));
    end;

    local procedure ExportNeeded(PurchCommentDocumentType: Enum "Purchase Comment Document Type"; DocumentNo: Code[20]): Boolean
    var
        PurchCommentLine: Record "Purch. Comment Line";
    begin
        PurchCommentLine.Reset();
        PurchCommentLine.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
        PurchCommentLine.SetRange("Document Type", PurchCommentDocumentType);
        PurchCommentLine.SetRange("No.", DocumentNo);
        PurchCommentLine.SetRange("Document Line No.", 0);
        PurchCommentLine.SetRange(Code, 'EXPORT');
        exit(PurchCommentLine.IsEmpty);
    end;

    local procedure InsertModifyExportMarker(PurchCommentDocumentType: Enum "Purchase Comment Document Type"; DocumentNo: Code[20])
    var
        PurchCommentLine: Record "Purch. Comment Line";
        LineNo: Integer;
    begin
        Clear(LineNo);

        PurchCommentLine.Reset();
        PurchCommentLine.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
        PurchCommentLine.SetRange("Document Type", PurchCommentDocumentType);
        PurchCommentLine.SetRange("No.", DocumentNo);
        PurchCommentLine.SetRange("Document Line No.", 0);
        if PurchCommentLine.FindLast() then
            LineNo := PurchCommentLine."Line No.";

        PurchCommentLine.SetRange(Code, 'EXPORT');
        if PurchCommentLine.FindFirst() then begin
            PurchCommentLine.Date := WorkDate();
            PurchCommentLine.Modify(false);
        end else begin
            PurchCommentLine.Reset();
            PurchCommentLine.Init();
            PurchCommentLine."Document Type" := PurchCommentDocumentType;
            PurchCommentLine."No." := DocumentNo;
            PurchCommentLine."Document Line No." := 0;
            PurchCommentLine."Line No." := LineNo + 10000;
            PurchCommentLine.Date := WorkDate();
            PurchCommentLine.Code := 'EXPORT';
            PurchCommentLine.Comment := 'Last Export Date';
            PurchCommentLine.insert(false);
        end;
    end;

    local procedure CreateBufferInvoice(DocumentNo: Code[20]): Boolean
    var
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchInvoiceLine: Record "Purch. Inv. Line";
        GeneralPostingSetup: Record "General Posting Setup";
        VATAmountLineTemp: Record "VAT Amount Line";
        VATPostingSetup: Record "VAT Posting Setup";
        Vendor: Record Vendor;
        CurrencyCode: Code[10];
        LineNo: Integer;
    begin
        Clear(FirstLogisticsDocumentNo);
        Clear(VendorInvoiceNo);
        Clear(CurrencyCode);
        Clear(LineNo);

        VATAmountLineTemp.Reset();
        VATAmountLineTemp.DeleteAll(false);

        if not PurchInvoiceHeader.Get(DocumentNo) then
            exit(false);
        PurchInvoiceHeader.CalcFields("Amount Including VAT");

        CurrencyCode := PurchInvoiceHeader."Currency Code";
        if CurrencyCode = '' then
            CurrencyCode := 'EUR';
        FirstLogisticsDocumentNo := GetFirstLogisticsNoInvoice(DocumentNo);
        VendorInvoiceNo := PurchInvoiceHeader."Vendor Invoice No.";

        if not Vendor.Get(PurchInvoiceHeader."Pay-to Vendor No.") then
            Clear(Vendor);

        PurchInvoiceLine.Reset();
        PurchInvoiceLine.SetCurrentKey("Document No.", Type, "Line No.");
        PurchInvoiceLine.SetRange("Document No.", DocumentNo);
        PurchInvoiceLine.SetFilter(Type, '%1|%2', PurchInvoiceLine.Type::"G/L Account", PurchInvoiceLine.Type::"WMS Service");
        PurchInvoiceLine.Setfilter("Line Amount", '<>%1', 0);
        if not PurchInvoiceLine.FindSet() then
            exit(false);

        InvoiceLineBuffer.Reset();
        InvoiceLineBuffer.Init();
        InvoiceLineBuffer."Document No." := DocumentNo;
        // InvoiceLineBuffer."3PL Doc. No." := FirstLogisticsDocumentNo;
        InvoiceLineBuffer."Line No." := LineNo;
        InvoiceLineBuffer."Posting Date" := PurchInvoiceHeader."Document Date";
        InvoiceLineBuffer."Description 2" := Vendor."3PL Attribute 01";
        InvoiceLineBuffer."Location Code" := CurrencyCode;
        InvoiceLineBuffer."Line Amount" := PurchInvoiceHeader."Amount Including VAT";
        InvoiceLineBuffer."Unit of Measure" := PurchInvoiceHeader."Vendor Invoice No.";
        InvoiceLineBuffer."System-Created Entry" := false;
        InvoiceLineBuffer.Insert(false);

        repeat
            if not VATPostingSetup.Get(PurchInvoiceline."VAT Bus. Posting Group", PurchInvoiceLine."VAT Prod. Posting Group") then
                Clear(VATPostingSetup);
            VATAmountLineTemp.Init();
            VATAmountLineTemp."VAT Identifier" := PurchInvoiceLine."VAT Identifier";
            VATAmountLineTemp."VAT Calculation Type" := PurchInvoiceLine."VAT Calculation Type";
            VATAmountLineTemp."Tax Group Code" := VATPostingSetup."Purchase VAT Account";
            VATAmountLineTemp."VAT %" := PurchInvoiceLine."VAT %";
            VATAmountLineTemp."VAT Base" := PurchInvoiceLine.Amount;
            VATAmountLineTemp."Amount Including VAT" := PurchInvoiceLine."Amount Including VAT";
            VATAmountLineTemp."Line Amount" := PurchInvoiceLine."Line Amount";
            VATAmountLineTemp."Tax Category" := VATPostingSetup."Tax Category";
            VATAmountLineTemp.InsertLine;

            InvoiceLineBuffer.Reset();
            InvoiceLineBuffer.Init();
            InvoiceLineBuffer.TransferFields(PurchInvoiceLine);
            InvoiceLineBuffer."VAT Identifier" := VATPostingSetup."Tax Category";
            InvoiceLineBuffer."Unit of Measure" := PurchInvoiceHeader."Vendor Invoice No.";
            InvoiceLineBuffer."Posting Date" := PurchInvoiceHeader."Document Date";
            InvoiceLineBuffer."Description 2" := Vendor."3PL Attribute 01";
            InvoiceLineBuffer."Location Code" := CurrencyCode;
            InvoiceLineBuffer."System-Created Entry" := false;
            InvoiceLineBuffer.Insert(false);

            if InvoiceLineBuffer."3PL Doc. No." = '' then
                InvoiceLineBuffer."3PL Doc. No." := FirstLogisticsDocumentNo;

            if InvoiceLineBuffer.Type = InvoiceLineBuffer.Type::"WMS Service" then begin
                if not GeneralPostingSetup.Get(InvoiceLineBuffer."Gen. Bus. Posting Group", InvoiceLineBuffer."Gen. Prod. Posting Group") then
                    Clear(GeneralPostingSetup);
                InvoiceLineBuffer."No." := GeneralPostingSetup."Purch. Account";
            end;
            InvoiceLineBuffer.Modify(false);
            if LineNo < InvoiceLineBuffer."Line No." then
                LineNo := InvoiceLineBuffer."Line No.";
        until PurchInvoiceLine.Next() = 0;

        VATAmountLineTemp.Reset();
        if VATAmountLineTemp.FindSet() then begin
            repeat
                LineNo += 10000;

                InvoiceLineBuffer.Reset();
                InvoiceLineBuffer.Init();
                InvoiceLineBuffer."Document No." := DocumentNo;
                // InvoiceLineBuffer."3PL Doc. No." := FirstLogisticsDocumentNo;
                InvoiceLineBuffer."Line No." := LineNo;
                InvoiceLineBuffer."No." := VATAmountLineTemp."Tax Group Code";
                InvoiceLineBuffer."Line Amount" := VATAmountLineTemp."VAT Amount";
                InvoiceLineBuffer."VAT Identifier" := VATAmountLineTemp."Tax Category";
                InvoiceLineBuffer."Posting Date" := PurchInvoiceHeader."Document Date";
                InvoiceLineBuffer."Description 2" := Vendor."3PL Attribute 01";
                InvoiceLineBuffer."Location Code" := CurrencyCode;
                InvoiceLineBuffer."Unit of Measure" := PurchInvoiceHeader."Vendor Invoice No.";
                InvoiceLineBuffer."System-Created Entry" := true;
                InvoiceLineBuffer.Insert(false);
            until VATAmountLineTemp.Next() = 0;
        end;

        // if not ((InvoiceLineBuffer."No." = '112TK') and (InvoiceLineBuffer."Line Amount" = 0)) then
        InvoiceLineBuffer.Reset();
        InvoiceLineBuffer.SetFilter("No.", '112TK|213TK');
        InvoiceLineBuffer.SetRange("Line Amount", 0);
        InvoiceLineBuffer.DeleteAll();

        InvoiceLineBuffer.Reset();
        InvoiceLineBuffer.SetCurrentKey("Document No.");
        InvoiceLineBuffer.SetRange("Document No.", DocumentNo);
        exit(not InvoiceLineBuffer.IsEmpty);
    end;

    local procedure GetFirstLogisticsNoInvoice(DocumentNo: Code[20]): COde[20]
    var
        PurchInvoiceLine: Record "Purch. Inv. Line";
    begin
        PurchInvoiceLine.Reset();
        PurchInvoiceLine.SetCurrentKey("Document No.", Type, "Line No.");
        PurchInvoiceLine.SetRange("Document No.", DocumentNo);
        PurchInvoiceLine.SetFilter(Type, '%1|%2', PurchInvoiceLine.Type::"G/L Account", PurchInvoiceLine.Type::"WMS Service");
        PurchInvoiceLine.Setfilter("Line Amount", '<>%1', 0);
        PurchInvoiceLine.SetFilter("3PL Doc. No.", '<>%1', '');
        PurchInvoiceLine.SetLoadFields("3PL Doc. No.");
        if PurchInvoiceLine.FindFirst() then
            exit(PurchInvoiceLine."3PL Doc. No.");
    end;

    local procedure ClearColumnsInvoice()
    begin
        Clear(InvoiceColumn01);
        Clear(InvoiceColumn02);
        Clear(InvoiceColumn03);
        Clear(InvoiceColumn04);
        Clear(InvoiceColumn05);
        Clear(InvoiceColumn06);
        Clear(InvoiceColumn07);
        Clear(InvoiceColumn08);
        Clear(InvoiceColumn09);
        Clear(InvoiceColumn10);
        Clear(InvoiceColumn11);
        Clear(InvoiceColumn12);
        Clear(InvoiceColumn13);
        Clear(InvoiceColumn14);
        Clear(InvoiceColumn15);
        Clear(InvoiceColumn16);
        Clear(InvoiceColumn17);
        Clear(InvoiceColumn18);
        Clear(InvoiceColumn19);
        Clear(InvoiceColumn20);
        Clear(InvoiceColumn21);
        Clear(InvoiceColumn22);
        Clear(InvoiceColumn23);
        Clear(InvoiceColumn24);
        Clear(InvoiceColumn25);
        Clear(InvoiceColumn26);
        Clear(InvoiceColumn27);
        Clear(InvoiceColumn28);
        Clear(InvoiceColumn29);
        Clear(InvoiceColumn30);
        Clear(InvoiceColumn31);
        Clear(InvoiceColumn32);
        Clear(InvoiceColumn33);
        Clear(InvoiceColumn34);
        Clear(InvoiceColumn35);
        Clear(InvoiceColumn36);
        Clear(InvoiceColumn37);
        Clear(InvoiceColumn38);
        Clear(InvoiceColumn39);
        Clear(InvoiceColumn40);
    end;

    local procedure FillCsvDataHeaderInvoice(LineNo: Integer)
    begin
        InvoiceColumn01 := Format(LineNo);
        InvoiceColumn02 := '311';
        InvoiceColumn03 := '30';
        InvoiceColumn06 := InvoiceLineBuffer."Unit of Measure";
        InvoiceColumn07 := InvoiceLineBuffer."3PL Doc. No.";
        InvoiceColumn08 := Format(InvoiceLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        InvoiceColumn11 := InvoiceLineBuffer."Description 2";
        InvoiceColumn13 := FormatDec(InvoiceLineBuffer."Line Amount");
        InvoiceColumn14 := 'J';
        InvoiceColumn15 := InvoiceLineBuffer."Location Code";
        InvoiceColumn24 := InvoiceLineBuffer."3PL Doc. No.";
        InvoiceColumn32 := 'N';
        InvoiceColumn40 := 'N';
    end;

    local procedure FillCsvDataLineInvoice(LineNo: Integer)
    begin
        InvoiceColumn01 := Format(LineNo);
        InvoiceColumn02 := '311';
        InvoiceColumn03 := '30';
        InvoiceColumn06 := InvoiceLineBuffer."Unit of Measure";
        InvoiceColumn07 := InvoiceLineBuffer."3PL Doc. No.";
        InvoiceColumn08 := Format(InvoiceLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        InvoiceColumn09 := InvoiceLineBuffer."No.";
        InvoiceColumn11 := InvoiceLineBuffer."Description 2";
        InvoiceColumn13 := FormatDec(InvoiceLineBuffer."Line Amount");
        InvoiceColumn14 := 'J';
        InvoiceColumn15 := InvoiceLineBuffer."Location Code";
        InvoiceColumn21 := InvoiceLineBuffer."VAT Identifier";
        InvoiceColumn24 := InvoiceLineBuffer."3PL Doc. No.";

        if not InvoiceLineBuffer."System-Created Entry" then begin
            InvoiceColumn27 := InvoiceLineBuffer."Shortcut Dimension 1 Code";
            InvoiceColumn28 := InvoiceLineBuffer."Shortcut Dimension 2 Code";
        end;
        InvoiceColumn32 := 'N';
        InvoiceColumn40 := 'N';
    end;

    local procedure CreateBufferCrMemo(DocumentNo: Code[20]): Boolean
    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        GeneralPostingSetup: Record "General Posting Setup";
        VATAmountLineTemp: Record "VAT Amount Line";
        VATPostingSetup: Record "VAT Posting Setup";
        Vendor: Record Vendor;
        // FirstLogisticsDocumentNo: Code[20];
        CurrencyCode: Code[10];
        LineNo: Integer;
    begin
        Clear(FirstLogisticsDocumentNo);
        Clear(CurrencyCode);
        Clear(LineNo);
        Clear(VendorInvoiceNo);

        VATAmountLineTemp.Reset();
        VATAmountLineTemp.DeleteAll(false);

        if not PurchCrMemoHeader.Get(DocumentNo) then
            exit(false);
        PurchCrMemoHeader.CalcFields("Amount Including VAT");

        CurrencyCode := PurchCrMemoHeader."Currency Code";
        if CurrencyCode = '' then
            CurrencyCode := 'EUR';
        FirstLogisticsDocumentNo := GetFirstLogisticsNoCrMemo(DocumentNo);
        VendorInvoiceNo := PurchCrMemoHeader."Vendor Cr. Memo No.";

        if not Vendor.Get(PurchCrMemoHeader."Pay-to Vendor No.") then
            Clear(Vendor);

        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetCurrentKey("Document No.", Type, "Line No.");
        PurchCrMemoLine.SetRange("Document No.", DocumentNo);
        PurchCrMemoLine.SetFilter(Type, '%1|%2', PurchCrMemoLine.Type::"G/L Account", PurchCrMemoLine.Type::"WMS Service");
        PurchCrMemoLine.Setfilter("Line Amount", '<>%1', 0);
        if not PurchCrMemoLine.FindSet() then
            exit(false);

        CrMemoLineBuffer.Reset();
        CrMemoLineBuffer.Init();
        CrMemoLineBuffer."Document No." := DocumentNo;
        // CrMemoLineBuffer."3PL Doc. No." := FirstLogisticsDocumentNo;
        CrMemoLineBuffer."Line No." := LineNo;
        CrMemoLineBuffer."Posting Date" := PurchCrMemoHeader."Document Date";
        CrMemoLineBuffer."Description 2" := Vendor."3PL Attribute 01";
        CrMemoLineBuffer."Location Code" := CurrencyCode;
        CrMemoLineBuffer."Line Amount" := PurchCrMemoHeader."Amount Including VAT";
        CrMemoLineBuffer."Unit of Measure" := PurchCrMemoHeader."Vendor Cr. Memo No.";
        CrMemoLineBuffer."System-Created Entry" := false;
        CrMemoLineBuffer.Insert(false);

        repeat
            if not VATPostingSetup.Get(PurchCrMemoline."VAT Bus. Posting Group", PurchCrMemoLine."VAT Prod. Posting Group") then
                Clear(VATPostingSetup);
            VATAmountLineTemp.Init();
            VATAmountLineTemp."VAT Identifier" := PurchCrMemoLine."VAT Identifier";
            VATAmountLineTemp."VAT Calculation Type" := PurchCrMemoLine."VAT Calculation Type";
            VATAmountLineTemp."Tax Group Code" := VATPostingSetup."Purchase VAT Account";
            VATAmountLineTemp."VAT %" := PurchCrMemoLine."VAT %";
            VATAmountLineTemp."VAT Base" := PurchCrMemoLine.Amount;
            VATAmountLineTemp."Amount Including VAT" := PurchCrMemoLine."Amount Including VAT";
            VATAmountLineTemp."Line Amount" := PurchCrMemoLine."Line Amount";
            VATAmountLineTemp."Tax Category" := VATPostingSetup."Tax Category";
            VATAmountLineTemp.InsertLine;

            CrMemoLineBuffer.Reset();
            CrMemoLineBuffer.Init();
            CrMemoLineBuffer.TransferFields(PurchCrMemoLine);
            CrMemoLineBuffer."Unit of Measure" := PurchCrMemoHeader."Vendor Cr. Memo No.";
            CrMemoLineBuffer."VAT Identifier" := VATPostingSetup."Tax Category";
            CrMemoLineBuffer."Posting Date" := PurchCrMemoHeader."Document Date";
            CrMemoLineBuffer."Description 2" := Vendor."3PL Attribute 01";
            CrMemoLineBuffer."Location Code" := CurrencyCode;
            CrMemoLineBuffer."System-Created Entry" := false;
            CrMemoLineBuffer.Insert(false);

            if CrMemoLineBuffer."3PL Doc. No." = '' then
                CrMemoLineBuffer."3PL Doc. No." := FirstLogisticsDocumentNo;

            if CrMemoLineBuffer.Type = CrMemoLineBuffer.Type::"WMS Service" then begin
                if not GeneralPostingSetup.Get(CrMemoLineBuffer."Gen. Bus. Posting Group", CrMemoLineBuffer."Gen. Prod. Posting Group") then
                    Clear(GeneralPostingSetup);
                CrMemoLineBuffer."No." := GeneralPostingSetup."Purch. Account";
            end;
            CrMemoLineBuffer.Modify(false);
            if LineNo < CrMemoLineBuffer."Line No." then
                LineNo := CrMemoLineBuffer."Line No.";
        until PurchCrMemoLine.Next() = 0;

        VATAmountLineTemp.Reset();
        if VATAmountLineTemp.FindSet() then begin
            repeat
                LineNo += 10000;

                CrMemoLineBuffer.Reset();
                CrMemoLineBuffer.Init();
                CrMemoLineBuffer."Document No." := DocumentNo;
                // CrMemoLineBuffer."3PL Doc. No." := FirstLogisticsDocumentNo;
                CrMemoLineBuffer."Line No." := LineNo;
                CrMemoLineBuffer."No." := VATAmountLineTemp."Tax Group Code";
                CrMemoLineBuffer."Line Amount" := VATAmountLineTemp."VAT Amount";
                CrMemoLineBuffer."VAT Identifier" := VATAmountLineTemp."Tax Category";
                CrMemoLineBuffer."Posting Date" := PurchCrMemoHeader."Document Date";
                CrMemoLineBuffer."Description 2" := Vendor."3PL Attribute 01";
                CrMemoLineBuffer."Location Code" := CurrencyCode;
                CrMemoLineBuffer."System-Created Entry" := true;
                CrMemoLineBuffer."Unit of Measure" := PurchCrMemoHeader."Vendor Cr. Memo No.";
                CrMemoLineBuffer.Insert(false);
            until VATAmountLineTemp.Next() = 0;
        end;

        // if not ((CrMemoLineBuffer."No." = '112TK') and (CrMemoLineBuffer."Line Amount" = 0)) then
        CrMemoLineBuffer.Reset();
        CrMemoLineBuffer.SetFilter("No.", '112TK|213TK');
        CrMemoLineBuffer.SetRange("Line Amount", 0);
        CrMemoLineBuffer.DeleteAll();

        CrMemoLineBuffer.Reset();
        CrMemoLineBuffer.SetCurrentKey("Document No.");
        CrMemoLineBuffer.SetRange("Document No.", DocumentNo);
        exit(not CrMemoLineBuffer.IsEmpty);
    end;

    local procedure GetFirstLogisticsNoCrMemo(DocumentNo: Code[20]): COde[20]
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetCurrentKey("Document No.", Type, "Line No.");
        PurchCrMemoLine.SetRange("Document No.", DocumentNo);
        PurchCrMemoLine.SetFilter(Type, '%1|%2', PurchCrMemoLine.Type::"G/L Account", PurchCrMemoLine.Type::"WMS Service");
        PurchCrMemoLine.Setfilter("Line Amount", '<>%1', 0);
        PurchCrMemoLine.SetFilter("3PL Doc. No.", '<>%1', '');
        PurchCrMemoLine.SetLoadFields("3PL Doc. No.");
        if PurchCrMemoLine.FindFirst() then
            exit(PurchCrMemoLine."3PL Doc. No.");
    end;

    local procedure ClearColumnsCrMemo()
    begin
        Clear(CrMemoColumn01);
        Clear(CrMemoColumn02);
        Clear(CrMemoColumn03);
        Clear(CrMemoColumn04);
        Clear(CrMemoColumn05);
        Clear(CrMemoColumn06);
        Clear(CrMemoColumn07);
        Clear(CrMemoColumn08);
        Clear(CrMemoColumn09);
        Clear(CrMemoColumn10);
        Clear(CrMemoColumn11);
        Clear(CrMemoColumn12);
        Clear(CrMemoColumn13);
        Clear(CrMemoColumn14);
        Clear(CrMemoColumn15);
        Clear(CrMemoColumn16);
        Clear(CrMemoColumn17);
        Clear(CrMemoColumn18);
        Clear(CrMemoColumn19);
        Clear(CrMemoColumn20);
        Clear(CrMemoColumn21);
        Clear(CrMemoColumn22);
        Clear(CrMemoColumn23);
        Clear(CrMemoColumn24);
        Clear(CrMemoColumn25);
        Clear(CrMemoColumn26);
        Clear(CrMemoColumn27);
        Clear(CrMemoColumn28);
        Clear(CrMemoColumn29);
        Clear(CrMemoColumn30);
        Clear(CrMemoColumn31);
        Clear(CrMemoColumn32);
        Clear(CrMemoColumn33);
        Clear(CrMemoColumn34);
        Clear(CrMemoColumn35);
        Clear(CrMemoColumn36);
        Clear(CrMemoColumn37);
        Clear(CrMemoColumn38);
        Clear(CrMemoColumn39);
        Clear(CrMemoColumn40);
    end;

    local procedure FillCsvDataHeaderCrMemo(LineNo: Integer)
    begin
        CrMemoColumn01 := Format(LineNo);
        CrMemoColumn02 := '211';
        CrMemoColumn03 := '30';
        CrMemoColumn06 := CrMemoLineBuffer."Unit of Measure";
        CrMemoColumn07 := CrMemoLineBuffer."3PL Doc. No.";
        CrMemoColumn08 := Format(CrMemoLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        CrMemoColumn11 := CrMemoLineBuffer."Description 2";
        CrMemoColumn13 := FormatDec(-CrMemoLineBuffer."Line Amount");
        CrMemoColumn14 := 'J';
        CrMemoColumn15 := CrMemoLineBuffer."Location Code";
        CrMemoColumn24 := FirstLogisticsDocumentNo;
        CrMemoColumn32 := 'N';
        CrMemoColumn40 := 'N';
    end;

    local procedure FillCsvDataLineCrMemo(LineNo: Integer)
    begin
        CrMemoColumn01 := Format(LineNo);
        CrMemoColumn02 := '211';
        CrMemoColumn03 := '30';
        CrMemoColumn06 := CrMemoLineBuffer."Unit of Measure";
        CrMemoColumn07 := CrMemoLineBuffer."3PL Doc. No.";
        CrMemoColumn08 := Format(CrMemoLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        CrMemoColumn09 := CrMemoLineBuffer."No.";
        CrMemoColumn11 := CrMemoLineBuffer."Description 2";
        CrMemoColumn13 := FormatDec(-CrMemoLineBuffer."Line Amount");
        CrMemoColumn14 := 'J';
        CrMemoColumn15 := CrMemoLineBuffer."Location Code";
        CrMemoColumn21 := CrMemoLineBuffer."VAT Identifier";
        CrMemoColumn24 := CrMemoLineBuffer."3PL Doc. No.";

        if not CrMemoLineBuffer."System-Created Entry" then begin
            CrMemoColumn27 := CrMemoLineBuffer."Shortcut Dimension 1 Code";
            CrMemoColumn28 := CrMemoLineBuffer."Shortcut Dimension 2 Code";
        end;
        CrMemoColumn32 := 'N';
        CrMemoColumn40 := 'N';
    end;
}