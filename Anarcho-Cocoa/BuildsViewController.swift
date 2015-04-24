import UIKit

class BuildsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        AnarchoAPI()
            .autorizaetion { () -> Void in
            AnarchoAPI().getApps { (applications) -> Void in
                println(applications)
                }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
    }
}
