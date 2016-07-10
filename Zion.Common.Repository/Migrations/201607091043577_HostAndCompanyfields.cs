namespace HrMaxx.Common.Repository.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class HostAndCompanyfields : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "Host", c => c.Guid());
            AddColumn("dbo.AspNetUsers", "Company", c => c.Guid());
						DropColumn("dbo.AspNetUsers", "Test");
        }
        
        public override void Down()
        {
            AddColumn("dbo.AspNetUsers", "Test", c => c.String());
						DropColumn("dbo.AspNetUsers", "Company");
            DropColumn("dbo.AspNetUsers", "Host");
        }
    }
}
