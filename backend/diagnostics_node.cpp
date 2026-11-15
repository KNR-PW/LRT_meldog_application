
#include "backend/diagnostics_node.hpp"

namespace backend {

DiagnosticsNode::DiagnosticsNode()
    : Node("meldog_diagnostics")
{
    jointSubscription_ =
        this->create_subscription<
            sensor_msgs::msg::JointState>(
            "/joint_states",
            10,
            [this](
                const sensor_msgs::msg::JointState::SharedPtr msg)
            {
                jointCallback(msg);
            }
        );

    RCLCPP_INFO(
        get_logger(),
        "Waiting for /joint_states..."
    );
}

void DiagnosticsNode::jointCallback(
    const sensor_msgs::msg::JointState::SharedPtr msg)
{
    for (size_t i = 0;
         i < msg->name.size() &&
         i < msg->position.size();
         ++i)
    {
        // RCLCPP_INFO(
        //     get_logger(),
        //     "Joint: %s | Position: %.3f rad",
        //     msg->name[i].c_str(),
        //     msg->position[i]
        // );

        if(this->jointUpdateCallback_ != nullptr){
            jointUpdateCallback_(msg->name[i], msg->position[i]);
        };
    }
}

void DiagnosticsNode::setJointUpdateCallback(
    std::function<void(const std::string&, double)> callback)
{
    this->jointUpdateCallback_ = callback;
}

}
