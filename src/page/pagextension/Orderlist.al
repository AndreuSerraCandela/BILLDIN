pageextension 90132 OrdeList extends "Purchase Order List"
{
    actions
    {
        addlast("O&rder")
        {
            action("Get Order List")
            {
                ApplicationArea = All;
                Image = OrderList;
                Caption = 'Lista pedidos BilldIN';
                ToolTip = 'Get Order List';
                trigger OnAction()
                var
                    BilldIn: Codeunit "BilldIn";
                begin
                    BilldIn."BilldIn-get-Order-List"();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(Getorderlist; "Get Order List") { }
        }
    }
}