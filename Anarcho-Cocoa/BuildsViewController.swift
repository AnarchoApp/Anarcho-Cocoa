import UIKit
import CoreData
class BuildsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    var applications : [Application] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Applications"
        AnarchoAPI().autorizaetion("dsay@ciklum.com", password: "8hYDrdiv") { () -> Void in
            AnarchoAPI().getApps { (app) -> Void in
                self.applications = app
                self.tableView.reloadData()
            }
            AnarchoAPI().getBuilds("0ec78bb8-c977-11e4-afd3-62dd4457b65e", completion: { (builds) -> Void in
                println(builds)
            })
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.applications.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let app = self.applications[section]
//        return app.app_type as String
//    }
//    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        var button = HamburgerButton(frame: CGRectMake(0, 0, 54, 54))
        button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        cell.accessoryView = button
        
        let app = self.applications[indexPath.section]
        cell.textLabel?.text = app.name as String
        cell.detailTextLabel?.text = app.package as String
        
        cell.imageView?.image = UIImage(named: "App")
        ImageLoader.sharedLoader.imageForUrl(app.icon_url as String, completionHandler: { (image, url) -> () in
            if let appIcon = image{
                cell.imageView?.image = appIcon
            }
        })
        return cell
    }
    
    func toggle(sender: HamburgerButton!) {
        if let button : HamburgerButton = sender {
            button.showsMenu = !button.showsMenu
        }
    }
}
