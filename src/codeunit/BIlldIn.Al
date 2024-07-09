Codeunit 50019 BiLldIn
{
    var
        Restapi: Codeunit "RestApi";
        GlSetup: Record "General ledger Setup";
        RequestType: Option Get,patch,put,post,delete;
        jSondtata: Text;
        Url: Text;
        GetOrdersList: Label 'order-get-list?apiKey=';//a9d5edd3-ad2a-4753-9de9-45fa303de959
        GetOrder: Label 'order-get?apiKey=';//a9d5edd3-ad2a-4753-9de9-45fa303de959
        Getbudget: Label 'budget-get?apiKey=';//a9d5edd3-ad2a-4753-9de9-45fa303de959
        ADDContact: Label 'contact-add';
        GetContact: Label 'contact-get-list?apiKey=';//a9d5edd3-ad2a-4753-9de9-45fa303de959
        Lista: Page ListaJson;

    procedure "BilldIn-get-Order-List"(): Text
    var
        JsonOrderList: JsonObject;
        jsonToken: JsonToken;
        jsonArr: JsonArray;
        jsonPedido: JsonObject;
        jSonArrayToken: jsonToken;
        proyect: Text;
        Order: Text;
    begin
        GlSetup.GET;
        Url := GlSetup."Ocr Url Api" + GetOrdersList + GlSetup."Api Key";
        //' https://api.app.billdin.com/public/order-get-list?apiKey=a9d5edd3-ad2a-4753-9de9-45fa303de959
        jSondtata := Restapi.RestApi(Url, RequestType::Get, '');
        JsonOrderList.ReadFrom(jSondtata);
        JsonOrderList.Get('orderList', jsonToken);
        jsonArr := jsonToken.AsArray();
        foreach jsonArrayToken in jsonArr do begin
            jsonPedido := jsonArrayToken.AsObject();
            Clear(jsonToken);
            jsonPedido.Get('projectPK', jsonToken);
            proyect := jsonToken.AsValue().AsText();
            Clear(jsonToken);
            jsonPedido.Get('PK', jsonToken);
            Order := jsonToken.AsValue().AsText();
            "BillDin-Get-Order"(Order, proyect);
        end;
        // {
        //     "orderList": [
        //         {
        //             "projectPK": "b11c51a4-e2ff-4edd-aed8-0e6c8420510c",
        //             "tax": {
        //                 "title": "IVA 21",
        //                 "value": "21,00"
        //             },
        //             "project": null,
        //             "GSI1SK": "ORD#97e52a06-3797-494b-afe1-78f8910b9507",
        //             "createdBy": "049a4c7f-9d22-44b9-af62-2e3c912cdbad",
        //             "GSI3SK": "ORD#97e52a06-3797-494b-afe1-78f8910b9507",
        //             "GSI2SK": "ORD#97e52a06-3797-494b-afe1-78f8910b9507",
        //             "state": "IMPUTED",
        //             "date": 1719930859467,
        //             "code": 0,
        //             "externalId": "1212",
        //             "imputedBudgetPK": "9037a96c-3d09-436a-8250-44e94d7b50a0",
        //             "SK": "ORD",
        //             "provider": null,
        //             "proformaList": [],
        //             "createdAt": 1719930922357,
        //             "orderConditions": {},
        //             "workspacePK": "3f30c2cd-7467-4936-9d22-07d0f2f2469d",
        //             "GSI2PK": "b11c51a4-e2ff-4edd-aed8-0e6c8420510c",
        //             "GSI1PK": "3f30c2cd-7467-4936-9d22-07d0f2f2469d",
        //             "amount": 2889.53,
        //             "paymentMethod": "CONTADO",
        //             "PK": "97e52a06-3797-494b-afe1-78f8910b9507",
        //             "title": "Compra Chapa",
        //             "type": "CLOSED"
        //         }
        //     ]
        // }
        //Clear(Lista);
        //Lista.CargaDatos(jSondtata, 'orderList');
        //Lista.RUNMODAL;
        //exit(jSondtata);
    end;

    procedure "Billdin-Get-Budget"(PkBudget: Text; Titulo: Text): Text
    var
        Job: Record Job;
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobJsonObj: JsonObject;
        ChildrenToken: JsonToken;
        SubChildrenToken: JsonToken;
        SubSubChildrenToken: JsonToken;
        ChildrenArrays: JsonArray;
        ChildrenArrays2: JsonArray;
        ChildrenArrays3: JsonArray;
        nature: Text;
        ChildrenObject: JsonObject;
        CampoToken: JsonToken;
        LineChapNo: Integer;
        LineSubChapNo: Integer;
        LineNo: Integer;
        Customer: Record Customer;
        Resource: Record Resource;
        Item: Record Item;
    begin
        GlSetup.GET;
        Url := GlSetup."Ocr Url Api" + Getbudget + GlSetup."Api Key" + '&projectPK=' + PkBudget;
        jSondtata := Restapi.RestApi(Url, RequestType::Get, '');
        Job.Init;
        Customer.FindFirst();
        job."Bill-to Customer No." := Customer."No.";
        Job.Insert(true);
        Job.Pk := PkBudget;
        job.Description := Titulo;
        Job.Modify();
        JobJsonObj.ReadFrom(jSondtata);
        JobJsonObj.Get('children', ChildrenToken);
        ChildrenArrays := ChildrenToken.AsArray();
        Clear(ChildrenToken);
        Chapter(ChildrenArrays, Job."No.");
        exit(Job."No.");
        //     {
        // "quantity": 1,
        // "salePrice": 418487.43,
        // "saleAmount": 418487.43,
        // "measurement": {
        //     "totalMeasurement": 0,
        //     "measurementLineList": []
        // },
        // "costQuantity": 1,
        // "costPrice": 418487.43,
        // "costAmount": 418487.43,
        // "costMeasurement": {
        //     "totalMeasurement": 0,
        //     "measurementLineList": []
        // },
        // "children": [
        //     {
        //         "nature": "CHAPTER",
        //         "summary": "ACTUACIONES PREVIAS",
        //         "fatherPK": "450be5e5-aed7-485a-8ab1-282840494147",
        //         "code": "CAP.-01",
        //         "isChildCostModified": true,
        //         "PK": "68e69ff8-793b-44c6-b54d-c94b09df0e03",
        //         "position": 0,
        //         "quantity": 1,
        //         "salePrice": 16529.1,
        //         "saleAmount": 16529.1,
        //         "costQuantity": 1,
        //         "costPrice": 16529.1,
        //         "costAmount": 16529.1,
        //         "children": [
        //             {
        //                 "nature": "SUBCHAPTER",
        //                 "summary": "ACONDICIONAMIENTO TERRENO",
        //                 "fatherPK": "68e69ff8-793b-44c6-b54d-c94b09df0e03",
        //                 "code": "SUB.-01.02",
        //                 "isChildCostModified": true,
        //                 "PK": "1860da28-35e2-4531-8ab4-235630991c58",
        //                 "position": 1,
        //                 "quantity": 1,
        //                 "salePrice": 1069.65,
        //                 "saleAmount": 1069.65,
        //                 "costQuantity": 1,
        //                 "costPrice": 1069.65,
        //                 "costAmount": 1069.65,
        //                 "children": [
        //                     {
        //                         "nature": "BATCH",
        //                         "unit": "m²",
        //                         "summary": "Refinado y nivelación tierras, medios manuales",
        //                         "fatherPK": "1860da28-35e2-4531-8ab4-235630991c58",
        //                         "code": "ECMZ.9a",
        //                         "PK": "00f23902-255d-49d2-b83b-8bb8b93f2f89",
        //                         "position": 1,
        //                         "quantity": 5.02,
        //                         "salePrice": 3.18,
        //                         "saleAmount": 15.96,
        //                         "measurement": {
        //                             "totalMeasurement": 5.02,
        //                             "measurementLineList": [
        //                                 {
        //                                     "comment": "Ajuste total medición",
        //                                     "units": 5.02,
        //                                     "partial": 5.02,
        //                                     "height": 0,
        //                                     "latitude": 0,
        //                                     "longitude": 0
        //                                 }
        //                             ],
        //                             "label": null
        //                         },
        //                         "costQuantity": 5.02,
        //                         "costPrice": 3.18,
        //                         "costAmount": 15.96,
        //                         "costMeasurement": {
        //                             "totalMeasurement": 5.02,
        //                             "measurementLineList": [
        //                                 {
        //                                     "comment": "Ajuste total medición",
        //                                     "units": 5.02,
        //                                     "partial": 5.02,
        //                                     "height": 0,
        //                                     "latitude": 0,
        //                                     "longitude": 0
        //                                 }
        //                             ],
        //                             "label": null
        //                         },
        //                         "children": [
        //                             {
        //                                 "nature": "WORKFORCE",
        //                                 "unit": "h",
        //                                 "summary": "Peón ordinario construcción",
        //                                 "fatherPK": "00f23902-255d-49d2-b83b-8bb8b93f2f89",
        //                                 "code": "MOOA12a",
        //                                 "PK": "7f86bd49-aad1-4370-81bb-fc158016af01",
        //                                 "position": 0,
        //                                 "thesaurus": [
        //                                     "construcción",
        //                                     "mano",
        //                                     "ordinario",
        //                                     "obra",
        //                                     "peon"
        //                                 ],
        //                                 "quantity": 0.2,
        //                                 "salePrice": 15.01,
        //                                 "saleAmount": 3,
        //                                 "costQuantity": 0.2,
        //                                 "costPrice": 15.01,
        //                                 "costAmount": 3
        //                             }
        //                         ]
        //                     },

    end;

    procedure Chapter(ChildrenArrays: JsonArray; JobNo: Text)
    var
        ChildrenToken: JsonToken;
        JobTask: Record "Job Task";
        ChildrenObject: JsonObject;
        CampoToken: JsonToken;
        nature: Text;
        LineChapNo: Integer;
        ChildrenArrays2: JsonArray;
        SubchildrenToken: JsonToken;
        LineNo: Integer;
        JobPlanningLine: Record "Job Planning Line";
        Item: Record Item;
        Resource: Record Resource;
    begin

        foreach Childrentoken in ChildrenArrays do begin
            JobTask.Init;
            Clear(ChildrenObject);
            ChildrenObject := Childrentoken.AsObject();
            Clear(CampoToken);
            ChildrenObject.Get('nature', CampoToken);

            nature := CampoToken.AsValue().AsText();
            If (nature = 'CHAPTER') OR (NATURE = 'SUBCHAPTER') then begin
                if nature = 'CHAPTER' then begin
                    LineChapNo += 10000;
                    JobTask.Init();
                    JobTask."Job No." := JobNo;
                    JobTask."Job Task No." := Format(LineChapNo);
                    JobTask."Job Task Type" := JobTask."Job Task Type"::Total;
                    JobTask.Totaling := Format(LineChapNo) + '..' + Format(LineChapNo + 9999);
                    Clear(CampoToken);
                    ChildrenObject.Get('summary', CampoToken);
                    JobTask.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                    JobTask.Insert();
                    Clear(SubChildrenToken);
                    Clear(ChildrenArrays2);
                    ChildrenObject.Get('children', SubChildrenToken);
                    ChildrenArrays2 := SubChildrenToken.AsArray();
                    Clear(SubChildrenToken);
                    SubChapter(ChildrenArrays2, JobNo, LineChapNo);
                end else begin
                    JobTask.Init();
                    JobTask."Job No." := JobNo;
                    JobTask."Job Task No." := Format(LineChapNo + 100);
                    JobTask."Job Task Type" := JobTask."Job Task Type"::Posting;
                    Clear(CampoToken);
                    ChildrenObject.Get('summary', CampoToken);
                    JobTask.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                    JobTask.Insert();
                    ChildrenObject.Get('children', SubChildrenToken);
                    ChildrenArrays2 := SubChildrenToken.AsArray();
                    Clear(SubChildrenToken);
                    PlaningLine(ChildrenArrays2, JobNo, JobTask."Job Task No.", 0);
                end;
            end else begin
                if (nature = 'BATCH') Or (nature = 'MATERIALS') or (nature = 'WORKFORCE') Or (nature = 'MACHINERY') then begin
                    LineNo += 10000;
                    JobPlanningLine.Init();
                    JobPlanningLine."Job No." := JobNo;
                    JobPlanningLine."Job Task No." := JobTask."Job Task No.";
                    JobTask.Get(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
                    JobTask."Job Task Type" := JobTask."Job Task Type"::Posting;
                    JobTask.Modify();
                    If nature = 'MATERIALS' then begin
                        Clear(CampoToken);
                        ChildrenObject.Get('code', CampoToken);
                        If Not Item.GET(CampoToken.AsValue().AsText()) then begin
                            Item.Init();
                            Item."No." := CampoToken.AsValue().AsText();
                            Clear(CampoToken);
                            ChildrenObject.Get('summary', CampoToken);
                            Item.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                            Item.Insert(true);
                            JobPlanningLine.Type := JobPlanningLine.Type::Item;
                            JobPlanningLine."No." := Item."No.";
                        end;
                    end else begin
                        Clear(CampoToken);
                        ChildrenObject.Get('code', CampoToken);
                        If Not Resource.GET(CampoToken.AsValue().AsText()) then begin
                            Resource.Init();
                            Resource."No." := CampoToken.AsValue().AsText();
                            Clear(CampoToken);
                            ChildrenObject.Get('summary', CampoToken);
                            Resource.Name := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                            Resource.Insert(true);
                            JobPlanningLine.Type := JobPlanningLine.Type::Resource;
                            JobPlanningLine."No." := Resource."No.";
                        end;
                    end;
                    Clear(CampoToken);
                    ChildrenObject.Get('summary', CampoToken);
                    JobPlanningLine.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                    repeat
                        JobPlanningLine."Line No." := LineNo;
                        LineNo += 10000;
                    until JobPlanningLine.Insert(true);
                    Clear(CampoToken);
                    ChildrenObject.Get('quantity', CampoToken);
                    JobPlanningLine.Quantity := CampoToken.AsValue().AsDecimal();
                    Clear(CampoToken);
                    ChildrenObject.Get('salePrice', CampoToken);
                    JobPlanningLine."Unit Price" := CampoToken.AsValue().AsDecimal();
                    Clear(CampoToken);
                    ChildrenObject.Get('costAmount', CampoToken);
                    JobPlanningLine."Unit Cost" := CampoToken.AsValue().AsDecimal();
                    Clear(CampoToken);
                    ChildrenObject.Get('PK', CampoToken);
                    JobPlanningLine.PK := CampoToken.AsValue().AsText();
                    JobPlanningLine.Modify(true);
                end;
            end;

        end;
    end;

    procedure SubChapter(ChildrenArrays: JsonArray; JobNo: Text; JobTaskNo: Integer)
    var
        ChildrenToken: JsonToken;
        JobTask: Record "Job Task";
        ChildrenObject: JsonObject;
        CampoToken: JsonToken;
        nature: Text;
        LineSubChapNo: Integer;
        ChildrenArrays3: JsonArray;
        SubChildrenToken: JsonToken;
        LineNo: Integer;
        JobPlanningLine: Record "Job Planning Line";
        Item: Record Item;
        Resource: Record Resource;
    begin
        LineSubChapNo := JobTaskNo;
        foreach ChildrenToken in ChildrenArrays do begin
            Clear(ChildrenObject);
            ChildrenObject := ChildrenToken.AsObject();
            Clear(CampoToken);
            ChildrenObject.Get('nature', CampoToken);
            nature := CampoToken.AsValue().AsText();
            if nature = 'SUBCHAPTER' then begin
                LineSubChapNo += 100;
                JobTask.Init();
                JobTask."Job No." := JobNo;
                JobTask."Job Task Type" := JobTask."Job Task Type"::Posting;
                JobTask."Job Task No." := Format(LineSubChapNo);
                JobTask.Totaling := Format(LineSubChapNo) + '..' + Format(LineSubChapNo + 99);
                Clear(CampoToken);
                ChildrenObject.Get('summary', CampoToken);
                JobTask.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                JobTask.Insert(true);
                Clear(SubChildrenToken);
                ChildrenObject.Get('children', SubChildrenToken);
                ChildrenArrays3 := SubChildrenToken.AsArray();
                planingLine(ChildrenArrays3, JobNo, JobTask."Job Task No.", 0);

                // end;
            end else begin
                LineNo += 10000;
                JobPlanningLine.Init();
                JobPlanningLine."Job No." := JobNo;
                JobPlanningLine."Job Task No." := Format(JobTaskNo);
                JobTask.Get(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
                JobTask."Job Task Type" := JobTask."Job Task Type"::Posting;
                JobTask.Modify();
                If nature = 'MATERIALS' then begin
                    Clear(CampoToken);
                    ChildrenObject.Get('code', CampoToken);
                    If Not Item.GET(CampoToken.AsValue().AsText()) then begin
                        Item.Init();
                        Item."No." := CampoToken.AsValue().AsText();
                        Clear(CampoToken);
                        ChildrenObject.Get('summary', CampoToken);
                        Item.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                        Item.Insert(true);
                        JobPlanningLine.Type := JobPlanningLine.Type::Item;
                        JobPlanningLine."No." := Item."No.";
                    end;
                end else begin
                    Clear(CampoToken);
                    ChildrenObject.Get('code', CampoToken);
                    If Not Resource.GET(CampoToken.AsValue().AsText()) then begin
                        Resource.Init();
                        Resource."No." := CampoToken.AsValue().AsText();
                        Clear(CampoToken);
                        ChildrenObject.Get('summary', CampoToken);
                        Resource.Name := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                        Resource.Insert(true);
                        JobPlanningLine.Type := JobPlanningLine.Type::Resource;
                        JobPlanningLine."No." := Resource."No.";
                    end;
                end;
                Clear(CampoToken);
                ChildrenObject.Get('summary', CampoToken);
                JobPlanningLine.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                repeat
                    JobPlanningLine."Line No." := LineNo;
                    LineNo += 10000;
                until JobPlanningLine.Insert(true);
                Clear(CampoToken);
                ChildrenObject.Get('quantity', CampoToken);
                JobPlanningLine.Quantity := CampoToken.AsValue().AsDecimal();
                Clear(CampoToken);
                ChildrenObject.Get('salePrice', CampoToken);
                JobPlanningLine."Unit Price" := CampoToken.AsValue().AsDecimal();
                Clear(CampoToken);
                ChildrenObject.Get('costAmount', CampoToken);
                JobPlanningLine."Unit Cost" := CampoToken.AsValue().AsDecimal();
                Clear(CampoToken);
                ChildrenObject.Get('PK', CampoToken);
                JobPlanningLine.PK := CampoToken.AsValue().AsText();
                JobPlanningLine.Modify(true);
                If ChildrenObject.Get('children', SubChildrenToken) then begin

                    ChildrenArrays3 := SubChildrenToken.AsArray();
                    planingLine(ChildrenArrays3, JobNo, JobTask."Job Task No.", JobPlanningLine."Line No.");
                end;
            end;
        end;
        nature := '';
    end;


    procedure PlaningLine(ChildrenArrays: JsonArray; JobNo: Text; JobTaskNo: Text; LineNo: Integer)
    var
        ChildrenToken: JsonToken;
        JobPlanningLine: Record "Job Planning Line";
        ChildrenObject: JsonObject;
        CampoToken: JsonToken;
        nature: Text;
        Item: Record Item;
        Resource: Record Resource;
        ChildrenArrays3: JsonArray;
        SubChildrenToken: JsonToken;
    begin
        foreach ChildrenToken in ChildrenArrays do begin
            Clear(ChildrenObject);
            LineNo += 10000;
            ChildrenObject := ChildrenToken.AsObject();
            Clear(CampoToken);
            ChildrenObject.Get('nature', CampoToken);
            nature := CampoToken.AsValue().AsText();

            //if nature= 'BATCH' then begin
            JobPlanningLine.Init();
            JobPlanningLine."Job No." := JobNo;
            JobPlanningLine."Job Task No." := JobTaskNo;
            If nature = 'MATERIALS' then begin
                Clear(CampoToken);
                ChildrenObject.Get('code', CampoToken);
                If Not Item.GET(CampoToken.AsValue().AsText()) then begin
                    Item.Init();
                    Item."No." := CampoToken.AsValue().AsText();
                    Clear(CampoToken);
                    ChildrenObject.Get('summary', CampoToken);
                    Item.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                    Item.Insert(true);
                    JobPlanningLine.Type := JobPlanningLine.Type::Item;
                    JobPlanningLine."No." := Item."No.";
                end;
            end else begin
                Clear(CampoToken);
                ChildrenObject.Get('code', CampoToken);
                If Not Resource.GET(CampoToken.AsValue().AsText()) then begin
                    Resource.Init();
                    Resource."No." := CampoToken.AsValue().AsText();
                    Clear(CampoToken);
                    ChildrenObject.Get('summary', CampoToken);
                    Resource.Name := Copystr(CampoToken.AsValue().AsText(), 1, 50);
                    Resource.Insert(true);
                    JobPlanningLine.Type := JobPlanningLine.Type::Resource;
                    JobPlanningLine."No." := Resource."No.";
                end;
            end;
            Clear(CampoToken);
            ChildrenObject.Get('summary', CampoToken);
            JobPlanningLine.Description := Copystr(CampoToken.AsValue().AsText(), 1, 50);
            repeat
                JobPlanningLine."Line No." := LineNo;
                LineNo += 10000;
            until JobPlanningLine.Insert(true);
            Clear(CampoToken);
            ChildrenObject.Get('quantity', CampoToken);
            JobPlanningLine.Quantity := CampoToken.AsValue().AsDecimal();
            Clear(CampoToken);
            ChildrenObject.Get('salePrice', CampoToken);
            JobPlanningLine."Unit Price" := CampoToken.AsValue().AsDecimal();
            Clear(CampoToken);
            ChildrenObject.Get('costAmount', CampoToken);
            JobPlanningLine."Unit Cost" := CampoToken.AsValue().AsDecimal();
            Clear(CampoToken);
            ChildrenObject.Get('PK', CampoToken);
            JobPlanningLine.PK := CampoToken.AsValue().AsText();
            JobPlanningLine.Modify(true);
            If ChildrenObject.Get('children', SubChildrenToken) then begin

                ChildrenArrays3 := SubChildrenToken.AsArray();
                planingLine(ChildrenArrays3, JobNo, JobPlanningLine."Job Task No.", JobPlanningLine."Line No.");
            end;
        end;
    end;

    procedure "BillDin-Get-Order"(OrderCode: Text; Proyecto: Text)
    Var
        PurchaseHeader: Record "Purchase Header";
        purchaseLine: Record "Purchase Line";
        Orderjson: JsonObject;
        OrdeLineJson: JsonObject;
        CampoToken: JsonToken;
        JobNo: Text;
        Vendor: Record Vendor;
        LineasArray: JsonArray;
        LineasToken: JsonToken;
        LineNo: Integer;
        JobPlanningLine: Record "Job Planning Line";
        Item: Record Item;
        Resource: Record Resource;
    begin
        PurchaseHeader.SetRange("PKOrder", OrderCode);
        If PurchaseHeader.FindSet() then
            exit;
        PurchaseHeader.Init();
        PurchaseHeader."No." := '';
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader."Posting Date" := WorkDate();
        PurchaseHeader.PKOrder := OrderCode;
        PurchaseHeader.Insert(true);
        GlSetup.GET;
        Url := GlSetup."Ocr Url Api" + GetOrder + GlSetup."Api Key" + '&orderPK=' + OrderCode;
        jSondtata := Restapi.RestApi(Url, RequestType::Get, '');
        Orderjson.ReadFrom(jSondtata);
        Orderjson.Get('title', CampoToken);
        JobNo := "Billdin-Get-Budget"(Proyecto, CampoToken.AsValue().AsText());
        //quitar
        commit;
        Clear(CampoToken);
        Orderjson.Get('providerPK', CampoToken);
        Vendor.SetRange("IdBilldIn", CampoToken.AsValue().AsText());
        Vendor.FindSet();
        PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");
        Clear(CampoToken);
        Orderjson.Get('externalId', CampoToken);
        PurchaseHeader."Vendor Order No." := CampoToken.AsValue().AsText();
        // Clear(CampoToken);
        // Orderjson.Get('PK', CampoToken);
        // PurchaseHeader.PKOrder := CampoToken.AsValue().AsText();
        PurchaseHeader.Modify();
        Clear(CampoToken);
        Orderjson.Get('imputationItems', CampoToken);
        LineasArray := CampoToken.AsArray();
        foreach lineastoken in lineasarray do begin
            Clear(OrdeLineJson);
            LineNo += 10000;
            OrdeLineJson := lineastoken.AsObject();
            PurchaseLine.Init();
            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
            PurchaseLine."Document No." := PurchaseHeader."No.";
            PurchaseLine."Line No." := LineNo;
            Clear(CampoToken);
            OrdeLineJson.Get('PK', CampoToken);
            JobPlanningLine.SetRange("PK", CampoToken.AsValue().AsText());
            JobPlanningLine.FindSet();
            PurchaseLine."Job No." := JobNo;
            if JobPlanningLine.Type = JobPlanningLine.Type::Item then begin
                PurchaseLine."Type" := PurchaseLine."Type"::Item;
                Item.GET(JobPlanningLine."No.");
                If item."Gen. Prod. Posting Group" = '' Then begin
                    Item."Gen. Prod. Posting Group" := 'MERCADERÍA';
                    Item.Modify();
                end;
                if Item."Inventory Posting Group" = '' then begin
                    Item."Inventory Posting Group" := 'MERCADERÍA';
                    Item.Modify();
                end;
                PurchaseLine.Validate("No.", JobPlanningLine."No.");

            end else begin
                PurchaseLine."Type" := PurchaseLine."Type"::Resource;
                Resource.GET(JobPlanningLine."No.");
                If Resource."Gen. Prod. Posting Group" = '' Then begin
                    Resource."Gen. Prod. Posting Group" := 'SERVICIOS';
                    Resource.Modify();
                end;
                PurchaseLine.Validate("No.", JobPlanningLine."No.");

            end;
            Clear(CampoToken);
            OrdeLineJson.Get('amount', CampoToken);
            purchaseLine.Validate(Quantity, 1);
            PurchaseLine."Direct Unit Cost" := CampoToken.AsValue().AsDecimal();
            purchaseLine.Insert(true);
        end;


        //     {
        //     "projectPK": "b11c51a4-e2ff-4edd-aed8-0e6c8420510c",
        //     "tax": {
        //         "title": "IVA 21",
        //         "value": "21,00"
        //     },
        //     "project": null,
        //     "GSI1SK": "ORD#97e52a06-3797-494b-afe1-78f8910b9507",
        //     "createdBy": "049a4c7f-9d22-44b9-af62-2e3c912cdbad",
        //     "GSI3SK": "ORD#97e52a06-3797-494b-afe1-78f8910b9507",
        //     "GSI2SK": "ORD#97e52a06-3797-494b-afe1-78f8910b9507",
        //     "state": "IMPUTED",
        //     "code": 0,
        //     "date": 1719930859467,
        //     "externalId": "1212",
        //     "imputedBudgetPK": "9037a96c-3d09-436a-8250-44e94d7b50a0",
        //     "SK": "ORD",
        //     "provider": null,
        //     "proformaList": [],
        //     "createdAt": 1719930922357,
        //     "orderConditions": {},
        //     "workspacePK": "3f30c2cd-7467-4936-9d22-07d0f2f2469d",
        //     "GSI2PK": "b11c51a4-e2ff-4edd-aed8-0e6c8420510c",
        //     "GSI1PK": "3f30c2cd-7467-4936-9d22-07d0f2f2469d",
        //     "amount": 2889.53,
        //     "paymentMethod": "CONTADO",
        //     "PK": "97e52a06-3797-494b-afe1-78f8910b9507",
        //     "title": "Compra Chapa",
        //     "type": "CLOSED",
        //     "documentList": [],
        //     "imputationItems": [
        //         {
        //             "PK": "a4819523-8c7a-4fbb-9c87-3042c0b79e34",
        //             "amount": 2889.53
        //         }
        //     ]
        // }
    end;

    procedure "Billdin-Add-Contact"(VendorCode: Code[20]; Type: Text): Text
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        JsonData: Text;
        JosonObject: JsonObject;
        JsonProperty: JsonObject;
        JosonArray: JsonArray;
        JsonToken: JsonToken;
    begin
        If Type = 'client' then
            Customer.GET(VendorCode)
        else
            Vendor.GET(VendorCode);

        GlSetup.GET;
        Url := GlSetup."Ocr Url Api" + ADDContact;
        JosonObject.Add('type', type);
        JosonObject.Add('apiKey', GlSetup."Api Key");
        Jsonproperty.Add('name', 'name');
        if Type = 'client' then
            Jsonproperty.Add('value', Customer.Name)
        else
            Jsonproperty.Add('value', Vendor.Name);
        JosonArray.Add(Jsonproperty);
        Clear(Jsonproperty);
        Jsonproperty.Add('name', 'ID');
        if Type = 'client' then
            Jsonproperty.Add('value', Customer."VAT Registration No.")
        else
            Jsonproperty.Add('value', Vendor."Vat Registration No.");
        JosonArray.Add(Jsonproperty);
        Clear(Jsonproperty);
        Jsonproperty.Add('name', 'type');
        Jsonproperty.Add('value', type);
        JosonArray.Add(Jsonproperty);
        Clear(Jsonproperty);
        //"email": "david.fdez.santos@maybecloud.es"
        Jsonproperty.Add('name', 'email');
        if Type = 'client' then
            Jsonproperty.Add('value', Customer."E-Mail")
        else
            Jsonproperty.Add('value', Vendor."E-Mail");
        JosonArray.Add(Jsonproperty);
        Clear(Jsonproperty);
        //"phone": "34600000000"
        Jsonproperty.Add('name', 'phone');
        if Type = 'client' then
            Jsonproperty.Add('value', Customer."Phone No.")
        else
            Jsonproperty.Add('value', Vendor."Phone No.");
        JosonArray.Add(Jsonproperty);
        Clear(Jsonproperty);
        //"address": "Calle de la Princesa, 5, 28008 Madrid, Spain"
        Jsonproperty.Add('name', 'address');
        if Type = 'client' then
            Jsonproperty.Add('value', Customer.Address)
        else
            Jsonproperty.Add('value', Vendor.Address);
        JosonArray.Add(Jsonproperty);
        Clear(Jsonproperty);

        JosonObject.Add('propertyList', JosonArray);
        JosonObject.WriteTo(jSondtata);
        jSondtata := Restapi.RestApi(Url, RequestType::Post, jSondtata);
        //"contactPK":"7a30ec4e-0bd1-4e8e-9eb3-2a45735109d2"
        Clear(JosonObject);
        JosonObject.ReadFrom(jSondtata);
        JosonObject.Get('contactPK', JsonToken);
        exit(JsonToken.AsValue().AsText());
        // {
        //     "type": "provider",
        //     "apiKey": "",
        //     "propertyList": [
        //         {
        //             "name": "name",
        //             "value": "Jose Martinez"
        //         },
        //         {
        //             "name": "ID",
        //             "value": "48683260B"
        //         },
        // {
        //             "name": "type",
        //             "value": null
        //         }
        //     ]
        // }
    end;

    procedure "Billdin-Get-Contact-List"(): Text
    begin
        GlSetup.GET;
        Url := GlSetup."Ocr Url Api" + GetContact + GlSetup."Api Key";
        jSondtata := Restapi.RestApi(Url, RequestType::Get, '');
        Clear(Lista);
        Lista.CargaDatos(jSondtata, 'contactList');
        Lista.RUNMODAL;
    end;
}