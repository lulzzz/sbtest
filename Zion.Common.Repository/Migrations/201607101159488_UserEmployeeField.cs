namespace HrMaxx.Common.Repository.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UserEmployeeField : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "Employee", c => c.Guid());
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "Employee");
        }
    }
}
