import UIKit
import CoreData
class BuildsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    var applications : [Application] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 60
        title = "Applications"
        
        AnarchoAPI().getBuilds("", completion: { (builds) -> Void in
            println(builds)
        })

    }

   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.applications.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
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
