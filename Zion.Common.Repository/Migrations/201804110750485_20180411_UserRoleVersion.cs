namespace HrMaxx.Common.Repository.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class _20180411_UserRoleVersion : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "RoleVersion", c => c.Int(nullable: false));
            AddColumn("dbo.AspNetUsers", "LastModifiedBy", c => c.String());
            AddColumn("dbo.AspNetUsers", "LastModified", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "LastModified");
            DropColumn("dbo.AspNetUsers", "LastModifiedBy");
            DropColumn("dbo.AspNetUsers", "RoleVersion");
        }
    }
}
