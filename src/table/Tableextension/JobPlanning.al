tableextension 90136 JobPlannigLinesExt extends "Job Planning Line"
{
    fields
    {
        field(92000; "Pk"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}
tableextension 90137 JobExt extends "Job"
{
    fields
    {
        field(92000; "Pk"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}