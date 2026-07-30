xmlport 91802 "3PL 308-Export Sales Period"
{
    Caption = 'Sales - Export Sales Documents Period SAP - CSV (Logisteed)';
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    Permissions = tabledata "Sales Comment Line" = rim;
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
                        // if not ((InvoiceLineBuffer."No." = '213TK') and (InvoiceLineBuffer."Line Amount" = 0)) then
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
                        // if not ((CrMemoLineBuffer."No." = '213TK') and (CrMemoLineBuffer."Line Amount" = 0)) then
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
        InvoiceLineBuffer: Record "Sales Invoice Line" temporary;
        CrMemoLineBuffer: Record "Sales Cr.Memo Line" temporary;
        TypeHelper: Codeunit "Type Helper";
        FromDate: Date;
        UntilDate: Date;
        Counter: Integer;
        Text001: Label 'Sales Documents.csv';

    local procedure FormatDec(ValueIn: Decimal): Text
    var
        Language: Codeunit Language;
    begin
        exit(TypeHelper.FormatDecimal(ValueIn, 'F2', Language.GetCultureName(GlobalLanguage)));
    end;


    local procedure CreateBuffer() BufferCreated: Boolean
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCommentDocumentType: Enum "Sales Comment Document Type";
    begin
        if FromDate = 0D then //werkdatum - 3maanden
            FromDate := CalcDate('-3M', WorkDate());

        if UntilDate = 0D then
            UntilDate := DMY2Date(1, 1, 9999);

        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetCurrentKey("Posting Date");
        SalesInvoiceHeader.SetRange("Posting Date", FromDate, UntilDate);
        if SalesInvoiceHeader.FindSet() then begin
            repeat
                if ExportNeeded(SalesCommentDocumentType::"Posted Invoice", SalesInvoiceHeader."No.") then begin
                    if CreateBufferInvoice(SalesInvoiceHeader."No.") then
                        InsertModifyExportMarker(SalesCommentDocumentType::"Posted Invoice", SalesInvoiceHeader."No.");
                end;
            until SalesInvoiceHeader.Next() = 0;
        end;

        SalesCrMemoHeader.Reset();
        SalesCrMemoHeader.SetCurrentKey("Posting Date");
        SalesCrMemoHeader.SetRange("Posting Date", FromDate, UntilDate);
        if SalesCrMemoHeader.FindSet() then begin
            repeat
                if ExportNeeded(SalesCommentDocumentType::"Posted Credit Memo", SalesCrMemoHeader."No.") then begin
                    if CreateBufferCrMemo(SalesCrMemoHeader."No.") then
                        InsertModifyExportMarker(SalesCommentDocumentType::"Posted Credit Memo", SalesCrMemoHeader."No.");
                end;
            until SalesCrMemoHeader.Next() = 0;
        end;

        InvoiceLineBuffer.Reset();
        CrMemoLineBuffer.Reset();
        exit(not (InvoiceLineBuffer.IsEmpty and CrMemoLineBuffer.IsEmpty));
    end;

    local procedure ExportNeeded(SalesCommentDocumentType: Enum "Sales Comment Document Type"; DocumentNo: Code[20]): Boolean
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        SalesCommentLine.Reset();
        SalesCommentLine.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
        SalesCommentLine.SetRange("Document Type", SalesCommentDocumentType);
        SalesCommentLine.SetRange("No.", DocumentNo);
        SalesCommentLine.SetRange("Document Line No.", 0);
        SalesCommentLine.SetRange(Code, 'EXPORT');
        exit(SalesCommentLine.IsEmpty);
    end;

    local procedure InsertModifyExportMarker(SalesCommentDocumentType: Enum "Sales Comment Document Type"; DocumentNo: Code[20])
    var
        SalesCommentLine: Record "Sales Comment Line";
        LineNo: Integer;
    begin
        Clear(LineNo);

        SalesCommentLine.Reset();
        SalesCommentLine.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
        SalesCommentLine.SetRange("Document Type", SalesCommentDocumentType);
        SalesCommentLine.SetRange("No.", DocumentNo);
        SalesCommentLine.SetRange("Document Line No.", 0);
        if SalesCommentLine.FindLast() then
            LineNo := SalesCommentLine."Line No.";

        SalesCommentLine.SetRange(Code, 'EXPORT');
        if SalesCommentLine.FindFirst() then begin
            SalesCommentLine.Date := WorkDate();
            SalesCommentLine.Modify(false);
        end else begin
            SalesCommentLine.Reset();
            SalesCommentLine.Init();
            SalesCommentLine."Document Type" := SalesCommentDocumentType;
            SalesCommentLine."No." := DocumentNo;
            SalesCommentLine."Document Line No." := 0;
            SalesCommentLine."Line No." := LineNo + 10000;
            SalesCommentLine.Date := WorkDate();
            SalesCommentLine.Code := 'EXPORT';
            SalesCommentLine.Comment := 'Last Export Date';
            SalesCommentLine.insert(false);
        end;
    end;

    local procedure CreateBufferInvoice(DocumentNo: Code[20]): Boolean
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        GeneralPostingSetup: Record "General Posting Setup";
        VATAmountLineTemp: Record "VAT Amount Line";
        VATPostingSetup: Record "VAT Posting Setup";
        Customer: Record Customer;
        FirstLogisticsDocumentNo: Code[20];
        CurrencyCode: Code[10];
        LineNo: Integer;
    begin
        Clear(FirstLogisticsDocumentNo);
        Clear(CurrencyCode);
        Clear(LineNo);

        VATAmountLineTemp.Reset();
        VATAmountLineTemp.DeleteAll(false);

        if not SalesInvoiceHeader.Get(DocumentNo) then
            exit(false);
        SalesInvoiceHeader.CalcFields("Amount Including VAT");

        CurrencyCode := SalesInvoiceHeader."Currency Code";
        if CurrencyCode = '' then
            CurrencyCode := 'EUR';
        FirstLogisticsDocumentNo := GetFirstLogisticsNoInvoice(DocumentNo);

        if not Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then
            Clear(Customer);

        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetCurrentKey("Document No.", Type, "Line No.");
        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        SalesInvoiceLine.SetFilter(Type, '%1|%2', SalesInvoiceLine.Type::"G/L Account", SalesInvoiceLine.Type::"WMS Service");
        SalesInvoiceLine.Setfilter("Line Amount", '<>%1', 0);
        if not SalesInvoiceLine.FindSet() then
            exit(false);

        InvoiceLineBuffer.Reset();
        InvoiceLineBuffer.Init();
        InvoiceLineBuffer."Document No." := DocumentNo;
        InvoiceLineBuffer."WMS Posted Doc. No." := FirstLogisticsDocumentNo;
        InvoiceLineBuffer."Line No." := LineNo;
        InvoiceLineBuffer."Posting Date" := SalesInvoiceHeader."Posting Date";
        InvoiceLineBuffer."Description 2" := Customer."3PL Attribute 01";
        InvoiceLineBuffer."Location Code" := CurrencyCode;
        InvoiceLineBuffer."Line Amount" := SalesInvoiceHeader."Amount Including VAT";
        InvoiceLineBuffer."System-Created Entry" := false;
        InvoiceLineBuffer.Insert(false);

        repeat
            if not VATPostingSetup.Get(SalesInvoiceline."VAT Bus. Posting Group", SalesInvoiceLine."VAT Prod. Posting Group") then
                Clear(VATPostingSetup);
            VATAmountLineTemp.Init();
            VATAmountLineTemp."VAT Identifier" := SalesInvoiceLine."VAT Identifier";
            VATAmountLineTemp."VAT Calculation Type" := SalesInvoiceLine."VAT Calculation Type";
            VATAmountLineTemp."Tax Group Code" := VATPostingSetup."Sales VAT Account";
            VATAmountLineTemp."VAT %" := SalesInvoiceLine."VAT %";
            VATAmountLineTemp."VAT Base" := SalesInvoiceLine.Amount;
            VATAmountLineTemp."Amount Including VAT" := SalesInvoiceLine."Amount Including VAT";
            VATAmountLineTemp."Line Amount" := SalesInvoiceLine."Line Amount";
            VATAmountLineTemp.InsertLine;

            InvoiceLineBuffer.Reset();
            InvoiceLineBuffer.Init();
            InvoiceLineBuffer.TransferFields(SalesInvoiceLine);
            InvoiceLineBuffer."Posting Date" := SalesInvoiceHeader."Posting Date";
            InvoiceLineBuffer."Description 2" := Customer."3PL Attribute 01";
            InvoiceLineBuffer."Location Code" := CurrencyCode;
            InvoiceLineBuffer."System-Created Entry" := false;
            InvoiceLineBuffer.Insert(false);

            if InvoiceLineBuffer."WMS Posted Doc. No." = '' then
                InvoiceLineBuffer."WMS Posted Doc. No." := FirstLogisticsDocumentNo;

            if InvoiceLineBuffer.Type = InvoiceLineBuffer.Type::"WMS Service" then begin
                if not GeneralPostingSetup.Get(InvoiceLineBuffer."Gen. Bus. Posting Group", InvoiceLineBuffer."Gen. Prod. Posting Group") then
                    Clear(GeneralPostingSetup);
                InvoiceLineBuffer."No." := GeneralPostingSetup."Sales Account";
            end;
            InvoiceLineBuffer.Modify(false);
            if LineNo < InvoiceLineBuffer."Line No." then
                LineNo := InvoiceLineBuffer."Line No.";
        until SalesInvoiceLine.Next() = 0;

        VATAmountLineTemp.Reset();
        if VATAmountLineTemp.FindSet() then begin
            repeat
                LineNo += 10000;

                InvoiceLineBuffer.Reset();
                InvoiceLineBuffer.Init();
                InvoiceLineBuffer."Document No." := DocumentNo;
                InvoiceLineBuffer."WMS Posted Doc. No." := FirstLogisticsDocumentNo;
                InvoiceLineBuffer."Line No." := LineNo;
                InvoiceLineBuffer."No." := VATAmountLineTemp."Tax Group Code";
                InvoiceLineBuffer."Line Amount" := VATAmountLineTemp."VAT Amount";
                InvoiceLineBuffer."VAT Identifier" := VATAmountLineTemp."VAT Identifier";
                InvoiceLineBuffer."Posting Date" := SalesInvoiceHeader."Posting Date";
                InvoiceLineBuffer."Description 2" := Customer."3PL Attribute 01";
                InvoiceLineBuffer."Location Code" := CurrencyCode;
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
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetCurrentKey("Document No.", Type, "Line No.");
        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        SalesInvoiceLine.SetFilter(Type, '%1|%2', SalesInvoiceLine.Type::"G/L Account", SalesInvoiceLine.Type::"WMS Service");
        SalesInvoiceLine.Setfilter("Line Amount", '<>%1', 0);
        SalesInvoiceLine.SetFilter("WMS Posted Doc. No.", '<>%1', '');
        SalesInvoiceLine.SetLoadFields("WMS Posted Doc. No.");
        if SalesInvoiceLine.FindFirst() then
            exit(SalesInvoiceLine."WMS Posted Doc. No.");
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
        InvoiceColumn02 := '312';
        InvoiceColumn03 := '40';
        InvoiceColumn06 := InvoiceLineBuffer."Document No.";
        InvoiceColumn07 := InvoiceLineBuffer."WMS Posted Doc. No.";
        InvoiceColumn08 := Format(InvoiceLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        InvoiceColumn10 := InvoiceLineBuffer."Description 2";
        InvoiceColumn13 := FormatDec(InvoiceLineBuffer."Line Amount");
        InvoiceColumn14 := 'J';
        InvoiceColumn15 := InvoiceLineBuffer."Location Code";
        InvoiceColumn24 := InvoiceLineBuffer."WMS Posted Doc. No.";
        InvoiceColumn32 := 'N';
        InvoiceColumn40 := 'N';
    end;

    local procedure FillCsvDataLineInvoice(LineNo: Integer)
    begin
        InvoiceColumn01 := Format(LineNo);
        InvoiceColumn02 := '312';
        InvoiceColumn03 := '40';
        InvoiceColumn06 := InvoiceLineBuffer."Document No.";
        InvoiceColumn07 := InvoiceLineBuffer."WMS Posted Doc. No.";
        InvoiceColumn08 := Format(InvoiceLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        InvoiceColumn09 := InvoiceLineBuffer."No.";
        InvoiceColumn10 := InvoiceLineBuffer."Description 2";
        InvoiceColumn13 := FormatDec(InvoiceLineBuffer."Line Amount");
        InvoiceColumn14 := 'J';
        InvoiceColumn15 := InvoiceLineBuffer."Location Code";
        InvoiceColumn21 := InvoiceLineBuffer."VAT Identifier";
        if not InvoiceLineBuffer."System-Created Entry" then begin
            InvoiceColumn27 := InvoiceLineBuffer."Shortcut Dimension 1 Code";
            InvoiceColumn28 := InvoiceLineBuffer."Shortcut Dimension 2 Code";
        end;
        InvoiceColumn32 := 'N';
        InvoiceColumn40 := 'N';
    end;

    local procedure CreateBufferCrMemo(DocumentNo: Code[20]): Boolean
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        GeneralPostingSetup: Record "General Posting Setup";
        VATAmountLineTemp: Record "VAT Amount Line";
        VATPostingSetup: Record "VAT Posting Setup";
        Customer: Record Customer;
        FirstLogisticsDocumentNo: Code[20];
        CurrencyCode: Code[10];
        LineNo: Integer;
    begin
        Clear(FirstLogisticsDocumentNo);
        Clear(CurrencyCode);
        Clear(LineNo);

        VATAmountLineTemp.Reset();
        VATAmountLineTemp.DeleteAll(false);

        if not SalesCrMemoHeader.Get(DocumentNo) then
            exit(false);
        SalesCrMemoHeader.CalcFields("Amount Including VAT");

        CurrencyCode := SalesCrMemoHeader."Currency Code";
        if CurrencyCode = '' then
            CurrencyCode := 'EUR';
        FirstLogisticsDocumentNo := GetFirstLogisticsNoCrMemo(DocumentNo);

        if not Customer.Get(SalesCrMemoHeader."Bill-to Customer No.") then
            Clear(Customer);

        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetCurrentKey("Document No.", Type, "Line No.");
        SalesCrMemoLine.SetRange("Document No.", DocumentNo);
        SalesCrMemoLine.SetFilter(Type, '%1|%2', SalesCrMemoLine.Type::"G/L Account", SalesCrMemoLine.Type::"WMS Service");
        SalesCrMemoLine.Setfilter("Line Amount", '<>%1', 0);
        if not SalesCrMemoLine.FindSet() then
            exit(false);

        CrMemoLineBuffer.Reset();
        CrMemoLineBuffer.Init();
        CrMemoLineBuffer."Document No." := DocumentNo;
        CrMemoLineBuffer."WMS Posted Doc. No." := FirstLogisticsDocumentNo;
        CrMemoLineBuffer."Line No." := LineNo;
        CrMemoLineBuffer."Posting Date" := SalesCrMemoHeader."Posting Date";
        CrMemoLineBuffer."Description 2" := Customer."3PL Attribute 01";
        CrMemoLineBuffer."Location Code" := CurrencyCode;
        CrMemoLineBuffer."Line Amount" := SalesCrMemoHeader."Amount Including VAT";
        CrMemoLineBuffer."System-Created Entry" := false;
        CrMemoLineBuffer.Insert(false);

        repeat
            if not VATPostingSetup.Get(SalesCrMemoline."VAT Bus. Posting Group", SalesCrMemoLine."VAT Prod. Posting Group") then
                Clear(VATPostingSetup);
            VATAmountLineTemp.Init();
            VATAmountLineTemp."VAT Identifier" := SalesCrMemoLine."VAT Identifier";
            VATAmountLineTemp."VAT Calculation Type" := SalesCrMemoLine."VAT Calculation Type";
            VATAmountLineTemp."Tax Group Code" := VATPostingSetup."Sales VAT Account";
            VATAmountLineTemp."VAT %" := SalesCrMemoLine."VAT %";
            VATAmountLineTemp."VAT Base" := SalesCrMemoLine.Amount;
            VATAmountLineTemp."Amount Including VAT" := SalesCrMemoLine."Amount Including VAT";
            VATAmountLineTemp."Line Amount" := SalesCrMemoLine."Line Amount";
            VATAmountLineTemp.InsertLine;

            CrMemoLineBuffer.Reset();
            CrMemoLineBuffer.Init();
            CrMemoLineBuffer.TransferFields(SalesCrMemoLine);
            CrMemoLineBuffer."Posting Date" := SalesCrMemoHeader."Posting Date";
            CrMemoLineBuffer."Description 2" := Customer."3PL Attribute 01";
            CrMemoLineBuffer."Location Code" := CurrencyCode;
            CrMemoLineBuffer."System-Created Entry" := false;
            CrMemoLineBuffer.Insert(false);

            if CrMemoLineBuffer."WMS Posted Doc. No." = '' then
                CrMemoLineBuffer."WMS Posted Doc. No." := FirstLogisticsDocumentNo;

            if CrMemoLineBuffer.Type = CrMemoLineBuffer.Type::"WMS Service" then begin
                if not GeneralPostingSetup.Get(CrMemoLineBuffer."Gen. Bus. Posting Group", CrMemoLineBuffer."Gen. Prod. Posting Group") then
                    Clear(GeneralPostingSetup);
                CrMemoLineBuffer."No." := GeneralPostingSetup."Sales Account";
            end;
            CrMemoLineBuffer.Modify(false);
            if LineNo < CrMemoLineBuffer."Line No." then
                LineNo := CrMemoLineBuffer."Line No.";
        until SalesCrMemoLine.Next() = 0;

        VATAmountLineTemp.Reset();
        if VATAmountLineTemp.FindSet() then begin
            repeat
                LineNo += 10000;

                CrMemoLineBuffer.Reset();
                CrMemoLineBuffer.Init();
                CrMemoLineBuffer."Document No." := DocumentNo;
                CrMemoLineBuffer."WMS Posted Doc. No." := FirstLogisticsDocumentNo;
                CrMemoLineBuffer."Line No." := LineNo;
                CrMemoLineBuffer."No." := VATAmountLineTemp."Tax Group Code";
                CrMemoLineBuffer."Line Amount" := VATAmountLineTemp."VAT Amount";
                CrMemoLineBuffer."VAT Identifier" := VATAmountLineTemp."VAT Identifier";
                CrMemoLineBuffer."Posting Date" := SalesCrMemoHeader."Posting Date";
                CrMemoLineBuffer."Description 2" := Customer."3PL Attribute 01";
                CrMemoLineBuffer."Location Code" := CurrencyCode;
                CrMemoLineBuffer."System-Created Entry" := true;
                CrMemoLineBuffer.Insert(false);
            until VATAmountLineTemp.Next() = 0;
        end;

        // if not ((CrMemoLineBuffer."No." = '213TK') and (CrMemoLineBuffer."Line Amount" = 0)) then
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
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetCurrentKey("Document No.", Type, "Line No.");
        SalesCrMemoLine.SetRange("Document No.", DocumentNo);
        SalesCrMemoLine.SetFilter(Type, '%1|%2', SalesCrMemoLine.Type::"G/L Account", SalesCrMemoLine.Type::"WMS Service");
        SalesCrMemoLine.Setfilter("Line Amount", '<>%1', 0);
        SalesCrMemoLine.SetFilter("WMS Posted Doc. No.", '<>%1', '');
        SalesCrMemoLine.SetLoadFields("WMS Posted Doc. No.");
        if SalesCrMemoLine.FindFirst() then
            exit(SalesCrMemoLine."WMS Posted Doc. No.");
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
        CrMemoColumn02 := '212';
        CrMemoColumn03 := '40';
        CrMemoColumn06 := CrMemoLineBuffer."Document No.";
        CrMemoColumn07 := CrMemoLineBuffer."WMS Posted Doc. No.";
        CrMemoColumn08 := Format(CrMemoLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        CrMemoColumn10 := CrMemoLineBuffer."Description 2";
        CrMemoColumn13 := FormatDec(-CrMemoLineBuffer."Line Amount");
        CrMemoColumn14 := 'J';
        CrMemoColumn15 := CrMemoLineBuffer."Location Code";
        CrMemoColumn24 := CrMemoLineBuffer."WMS Posted Doc. No.";
        CrMemoColumn32 := 'N';
        CrMemoColumn40 := 'N';
    end;

    local procedure FillCsvDataLineCrMemo(LineNo: Integer)
    begin
        CrMemoColumn01 := Format(LineNo);
        CrMemoColumn02 := '212';
        CrMemoColumn03 := '40';
        CrMemoColumn06 := CrMemoLineBuffer."Document No.";
        CrMemoColumn07 := CrMemoLineBuffer."WMS Posted Doc. No.";
        CrMemoColumn08 := Format(CrMemoLineBuffer."Posting Date", 0, '<Day,2><Month,2><Year4>');
        CrMemoColumn09 := CrMemoLineBuffer."No.";
        CrMemoColumn10 := CrMemoLineBuffer."Description 2";
        CrMemoColumn13 := FormatDec(-CrMemoLineBuffer."Line Amount");
        CrMemoColumn14 := 'J';
        CrMemoColumn15 := CrMemoLineBuffer."Location Code";
        CrMemoColumn21 := CrMemoLineBuffer."VAT Identifier";
        if not CrMemoLineBuffer."System-Created Entry" then begin
            CrMemoColumn27 := CrMemoLineBuffer."Shortcut Dimension 1 Code";
            CrMemoColumn28 := CrMemoLineBuffer."Shortcut Dimension 2 Code";
        end;
        CrMemoColumn32 := 'N';
        CrMemoColumn40 := 'N';
    end;
}